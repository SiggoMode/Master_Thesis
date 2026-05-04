#include <SoftwareSerial.h>
#include <RoboClaw.h>
#include "Adafruit_VL53L0X.h"


/*
NOTE:

Whenever an array is presented reffering to a parameter, address, sensor etc. It is ordered such that the indices correspond to the following muscle/actuator:
Front deltoid
Middle deltoid
Rear deltoid
Anterior Upper Rotator
Anterior Lower Rotator
Posterior Upper Rotator
Posterior Lower Rotator

*/

//LiquidCrystal lcd(12, 11, 5, 4, 3, 2)
const int switchPin = 6;
int reply;

// System parameters
const int N_ACTUATORS = 7;
const float KP[N_ACTUATORS] = {1, 1, 0.5, 4, 4, 4, 0.5};
const float KI[N_ACTUATORS] = {0};
const float KD[N_ACTUATORS] = {0};
float i_contributions[N_ACTUATORS] = {0};
float prev_errors[N_ACTUATORS] = {0};
float previous_errors[N_ACTUATORS] = {0};
float dt = 0.01;
unsigned long dt_millis = 100; //milliseconds
unsigned long prev_time = millis();
float set_values[N_ACTUATORS] = {60, 70, 60, 60, 50, 55, 80};
float u[N_ACTUATORS] = {64};
#define u_saturation_l 0
#define u_saturation_u 127
#define u_bias 64
#define i_saturation_l -10
#define i_saturation_u 10


// Roboclaw
SoftwareSerial serial(16,17); // RoboClaw communication
RoboClaw roboclaw(&serial,10000);
#define address1 0x80 // Address to RoboClaw controller
#define address2 0x81
#define address3 0x82
#define address4 0x83

bool stopAll = true;
bool dir = 1;


// Range sensors
Adafruit_VL53L0X lox[N_ACTUATORS] = Adafruit_VL53L0X();
//const int XSHUT[6] = {2,3,4,5,6,7};
const int XSHUT[7] = {41,43,45,47,49,51,53};
//const int XSHUT[1] = {49};
const byte TOF_ADDRESSES[7] = {0x36, 0x35, 0x34, 0x33, 0x32, 0x31, 0x30};
const int DISTANCE_SENSOR_N = sizeof(XSHUT) / sizeof(XSHUT[0]);
const float FIR_COEFFS[5] = { 0.028, 0.237, 0.470, 0.237, 0.028 };
const int FIR_N = sizeof(FIR_COEFFS) / sizeof(FIR_COEFFS[0]);
float tof_buffer[7][5] = {0};
int matchCount[N_ACTUATORS-1] = {0};

#define MATCH_THRESHOLD 4



// End switches
const int END_SWITCH[4] = {31, 33, 35, 37};
const int END_SWITCH_N = sizeof(END_SWITCH) / sizeof(END_SWITCH[0]);
const int DEAD_MAN_SWITCH = 29;

String simulink_string = "";
bool string_complete = false;

void setup() {
  Serial.begin(115200);
  // wait until serial port opens for native USB devices
  while (! Serial) {
    delay(1);
  }


  roboclaw.begin(38400); // Open roboclaw serial ports
  for (int i = 0; i < END_SWITCH_N; i++) {
    pinMode(END_SWITCH[i], INPUT);
  }
  pinMode(DEAD_MAN_SWITCH, INPUT);


  pinMode(23, OUTPUT);
  
   
  boot_TOF_sensors();
}

void loop() {
  prev_time = millis();
  
  
  if(Serial.available()) { // Check for incoming manual steering signals
    char incoming_byte = Serial.read();
    Serial.print(incoming_byte);
    if ((char)incoming_byte == ' ') {
      Serial.println("Stop signal received ");
      stopAll = true;
    }
    if ((char)incoming_byte == 'c') {
      Serial.println("Continue signal received");
      stopAll = false;
    }
    if ((char)incoming_byte == 'u') {
      Serial.println("Upward signal received");
      dir = 1;
    }
    if ((char)incoming_byte == 'd') {
      Serial.println("Down signal received");
      dir = 0;
    }
  }
  

  if (digitalRead(DEAD_MAN_SWITCH)) { stopAll = false; }
  else { stopAll = true; 
  //Serial.println("Dead man switch activated"); 
  }
  //Serial.print("Stopall state: ");
  //Serial.println(stopAll);

  //serialEvent();
  //parseData(simulink_string);

  /*
  for (int i=0;i<N_ACTUATORS;i++) {
    Serial.print("Input ");
    Serial.print(i+1);
    Serial.print(": ");
    Serial.println(set_values[i]);
  }
  */


  VL53L0X_RangingMeasurementData_t measure;
  float tof_sensor_meas[DISTANCE_SENSOR_N] = {0};
  float previous_measurement = 0.0;
  
  for (int i = 0; i<DISTANCE_SENSOR_N; i++) {
    //Serial.print("Sensor reading ");
    //Serial.print(i+1);
    //Serial.print(": ");
    if (lox[i].timeoutOccurred()) { boot_TOF_sensors(); }
    lox[i].rangingTest(&measure, false);

    if (measure.RangeStatus != 4) {  // phase failures have incorrect data
      tof_sensor_meas[i] = measure.RangeMilliMeter;
      } else {
      //Serial.println(" out of range ");
    }

  }
  
  updateTofBuffer(tof_sensor_meas);
  float tof_FIR_filtered[DISTANCE_SENSOR_N] = {0};
  checkForMirroring();
  firFilter(tof_FIR_filtered);
  
  
  /*
  for (int i = 0; i<DISTANCE_SENSOR_N; i++) {
    Serial.print("Filtered distance sensor");
    Serial.print(i+1);
    Serial.print(": ");
    Serial.println(tof_FIR_filtered[i]);
  }
  */

  

  int actuator = 6;
  //testPid(tof_FIR_filtered, actuator);
/*
  Serial.print("Output from PID: ");
  Serial.println(u[actuator]);
  */
  /*
  if (!digitalRead(END_SWITCH[0])) {
    Serial.println("Rear delt limit switch activated");
    stopAll = true;
  }
  //if (!digitalRead(END_SWITCH[1])) {
  //  Serial.println("Switch 2 detected");
  //}
  if (!digitalRead(END_SWITCH[2])) {
    Serial.println("Front delt limit switch activated");
    stopAll = true;
  }
  if (!digitalRead(END_SWITCH[3])) {
    Serial.println("Middle delt limit switch activated");
    stopAll = true;
  }
  */
  pid(tof_FIR_filtered);
  steerMotors();

  if (stopAll) {
    roboclaw.ForwardBackwardM1(address1, 64);
    roboclaw.ForwardBackwardM2(address1, 64);
    roboclaw.ForwardBackwardM1(address2, 64);
    roboclaw.ForwardBackwardM2(address2, 64);
    roboclaw.ForwardBackwardM1(address3, 64);
    roboclaw.ForwardBackwardM2(address3, 64);
    roboclaw.ForwardBackwardM1(address4, 64);
  }
   
  
  while((millis() - prev_time) < dt_millis) {}
}

void firFilter(float output[]) {
  for (int k=0;k<DISTANCE_SENSOR_N;k++) {
    output[k] = 0;
    for (int i = 0; i < FIR_N; i++) {
        output[k] += FIR_COEFFS[i] * tof_buffer[k][i];
    }
  }
}

void updateTofBuffer(float input[]) {
    for (int k = 0; k < DISTANCE_SENSOR_N; k++) {
      for (int i = FIR_N-1; i > 0; i--) {
        tof_buffer[k][i] = tof_buffer[k][i-1];
      }
      tof_buffer[k][0] = input[k];
    }
}

void pid(float measurements[]) {
  for (int i=0;i<N_ACTUATORS;i++) {
    float error = set_values[i] - measurements[i];
    float p = KP[i] * error;
    i_contributions[i] = KI[i] * error * dt + i_contributions[i];
    float d = KD[i] * (error - prev_errors[i]) / dt;

    if (i_contributions[i] < i_saturation_l) { i_contributions[i] = i_saturation_l; }
    if (i_contributions[i] > i_saturation_u) { i_contributions[i] = i_saturation_u; }
    prev_errors[i] = error;

    int output = int(p+i_contributions[i]+d) + u_bias;
    if (output < u_saturation_l) { output = u_saturation_l; }
    if (output > u_saturation_u) { output = u_saturation_u; }

    u[i] = output;
  }
}

void testPid(float measurements[], int actuator) {
  float error = set_values[actuator] - measurements[actuator];
  float p = KP[actuator] * error;

  int output = int(p) + u_bias;
    if (output < u_saturation_l) { output = u_saturation_l; }
    if (output > u_saturation_u) { output = u_saturation_u; }

    u[actuator] = output;
}

void boot_TOF_sensors() {
  for (int i = 0; i<DISTANCE_SENSOR_N; i++) {
    pinMode(XSHUT[i], OUTPUT);
    digitalWrite(XSHUT[i], LOW);
  } delay(10);

  for (int i = 0; i<DISTANCE_SENSOR_N; i++) {
    digitalWrite(XSHUT[i], HIGH);
  } delay(10);

  for (int i = 1; i<DISTANCE_SENSOR_N; i++) { // Set all except sensor 1 in offline
    digitalWrite(XSHUT[i], LOW);
  } delay(10);

  for (int i = 0; i<DISTANCE_SENSOR_N; i++) {
    digitalWrite(XSHUT[i], HIGH);
    //Serial.print("Connecting to sensor: ");
    //Serial.println(i+1);
    
    while(!lox[i].begin(TOF_ADDRESSES[i])) {
      //Serial.print(F("Failed to boot Sensor: "));
      //Serial.println({i+1});
      delay(1000);
    }
    
    delay(10);
  }
}


void steerMotors() {
  int speed;
  if (dir == true) {
    speed = 73;
  }
  else {
    speed = 53;
  }
  //Serial.print("Speed: ");
  //Serial.println(speed);
  if (stopAll) { 
    for (int i=0;i<N_ACTUATORS;i++) { u[i] = 64; }  // Set all motors to stop (64)
  }
  else {
    /*
    Front deltoid
    Middle deltoid
    Rear deltoid
    Anterior Upper Rotator
    Anterior Lower Rotator
    Posterior Upper Rotator
    Posterior Lower Rotator
    */
    /*
  for (int i = 0; i<N_ACTUATORS;i++) {
    Serial.println(u[i]);
  }
    */
    //roboclaw.ForwardBackwardM2(address3, u[6]);
    
    roboclaw.ForwardBackwardM1(address1, speed);
    Serial.print("We tryna make the motor go: ");
    Serial.println(speed);
    
    /*
    roboclaw.ForwardBackwardM1(address1, u[0]);
    roboclaw.ForwardBackwardM1(address2, u[1]);
    roboclaw.ForwardBackwardM2(address2, u[2]);
    roboclaw.ForwardBackwardM1(address4, u[3]);
    roboclaw.ForwardBackwardM2(address1, u[4]);
    roboclaw.ForwardBackwardM1(address3, u[5]);
    */
    //roboclaw.ForwardBackwardM1(address4, u[6]);
    
  }
}

/*
void serialEvent() {
  while (Serial.available() && !string_complete) {
    if (digitalRead(DEAD_MAN_SWITCH)) { stopAll = false; }
    else { stopAll = true; }
    steerMotors();
    //Serial.println("E det fremdeles her?");
    char inChar = (char)Serial.read();
    bool endline_reached = (inChar == '\n');

    if (endline_reached) { string_complete = true; }
    else { simulink_string += inChar; }
    if 
  }
  string_complete = false;
}*/


void parseData(String data) {
  data.trim();

    if (data.startsWith("<") && data.endsWith(">")) {

    data.remove(0, 1);              // remove '<'
    data.remove(data.length()-1);   // remove '>\n'

    int index = 0;
    char *token = strtok((char*)data.c_str(), ",");

    while (token != NULL && index < 7) {
      set_values[index++] = atoi(token);
      token = strtok(NULL, ",");
    }
  }
  simulink_string = "";
}


void checkForMirroring() {

  for (int i = 1; i < N_ACTUATORS; i++) {

    uint16_t valA = tof_buffer[i][0];
    uint16_t valB = tof_buffer[i - 1][0];

    // Compare with tolerance
    if (abs((int)valA - (int)valB) < 0.01) {
      matchCount[i]++;
    } else {
      matchCount[i] = 0;
    }

    // If sensor i looks like sensor i-1 → problem
    if (matchCount[i] >= MATCH_THRESHOLD) {
      //Serial.print("Sensor ");
      //Serial.print(i);
      //Serial.println(" mirrors previous sensor. Reinitializing...");
      stopAll = true;
      steerMotors();

      boot_TOF_sensors();

      matchCount[i] = 0;
    }
  }
}
