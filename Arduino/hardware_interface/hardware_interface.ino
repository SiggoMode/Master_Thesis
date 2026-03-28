#include <SoftwareSerial.h>
#include <HX711.h>
#include <RoboClaw.h>
#include "Adafruit_VL53L0X.h"
#include <LiquidCrystal.h>

#define CLK1 2
#define DOUT1 3
#define CLK2 4
#define DOUT2 5
#define CLK3 6
#define DOUT3 7
#define CLK4 8
#define DOUT4 9
#define CLK5 10
#define DOUT5 11
#define CLK6 12
#define DOUT6 13
#define CLK7 14
#define DOUT7 15

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

LiquidCrystal lcd(12, 11, 5, 4, 3, 2)
const int switchPin = 6;
int reply;

// System parameters
const int N_ACTUATORS = 7;
const float KP[N_ACTUATORS] = {1, 0, 0, 0, 0, 0, 0};
const float KI[N_ACTUATORS] = {0};
const float KD[N_ACTUATORS] = {0};
float i_contributions[N_ACTUATORS] = {0};
float prev_errors[N_ACTUATORS] = {0};
float previous_errors[N_ACTUATORS] = {0};
float dt = 0.01;
unsigned long dt_millis = 1000; //milliseconds
unsigned long prev_time = millis();
float set_values[N_ACTUATORS] = {50, 100, 100, 100, 100, 100, 100};
float u[N_ACTUATORS] = {0};
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

// Load cell readings
HX711 scales[N_ACTUATORS];
HX711 scale1;
HX711 scale2;
HX711 scale3;
HX711 scale4;
HX711 scale5;
HX711 scale6;
HX711 scale7;

// Range sensors
Adafruit_VL53L0X lox[N_ACTUATORS] = Adafruit_VL53L0X();
//const int XSHUT[6] = {2,3,4,5,6,7};
//const int XSHUT[3] = {49,51,53};
const int XSHUT[1] = {49};
const byte TOF_ADDRESSES[6] = {0x35, 0x34, 0x33, 0x32, 0x31, 0x30};
const int DISTANCE_SENSOR_N = sizeof(XSHUT) / sizeof(XSHUT[0]);
const float FIR_COEFFS[5] = { 0.028, 0.237, 0.470, 0.237, 0.028 };
const int FIR_N = sizeof(FIR_COEFFS) / sizeof(FIR_COEFFS[0]);
float buffer[3][5] = {0};


int Load_Cell_Value[N_ACTUATORS];
int offset[1];

// End switches
const int END_SWITCH[4] = {31, 33, 35, 37};
const int END_SWITCH_N = sizeof(END_SWITCH) / sizeof(END_SWITCH[0]);

String simulink_string = "";
bool string_complete = false;

void setup() {
  Serial.begin(115200);
  // wait until serial port opens for native USB devices
  while (! Serial) {
    delay(1);
  }

  lcd.begin(16,2);
  lcd.print("Ask the");
  lcd.setCursor(0,1);
  lcd.print("Crystal Ball!");

/*
  roboclaw.begin(38400); // Open coboclaw serial ports
  for (int i = 0; i < END_SWITCH_N; i++) {
    pinMode(END_SWITCH[i], INPUT);
  }


  scale1.begin(DOUT1, CLK1);
  scale2.begin(DOUT2, CLK2);
  scale3.begin(DOUT3, CLK3);
  scale4.begin(DOUT4, CLK4);
  scale5.begin(DOUT5, CLK5);
  scale6.begin(DOUT6, CLK6);
  scale7.begin(DOUT7, CLK7);

  // Calibrating
 scale1.set_scale(14);
 scale2.set_scale(14);
 scale3.set_scale(14);
 scale4.set_scale(14);
 scale5.set_scale(14);
 scale6.set_scale(14);
 scale7.set_scale(14);
   
   offset[0] = 1015;
   boot_TOF_sensors();

   pinMode(23, OUTPUT);
   */
}

void loop() {
  prev_time = millis();

  serialEvent();
  parseData(simulink_string);
  if (set_values[0] == 120) {
    digitalWrite(23, HIGH);
  } else {
    digitalWrite(23, LOW);
  }

  for (int i=0;i<N_ACTUATORS;i++) {
    Serial.print("Input ");
    Serial.print(i+1);
    Serial.print(": ");
    Serial.println(set_values[i]);
  }

  /*
  if(Serial.available()) { // Check for incoming stop signal
    char incoming_byte = Serial.read();
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
  */


  VL53L0X_RangingMeasurementData_t measure;
  float tof_sensor_meas[DISTANCE_SENSOR_N] = {0};
  /*
  for (int i = 0; i<DISTANCE_SENSOR_N; i++) {
    Serial.print("Sensor reading ");
    Serial.print(i+1);
    Serial.print(": ");
    
    lox[i].rangingTest(&measure, false);

    if (measure.RangeStatus != 4) {  // phase failures have incorrect data
      tof_sensor_meas[i] = measure.RangeMilliMeter;
      } else {
      Serial.println(" out of range ");
    }
  }
  
  updateBuffer(tof_sensor_meas);
  float tof_FIR_filtered[DISTANCE_SENSOR_N] = {0};
  firFilter(tof_FIR_filtered);
  */
  /*
  for (int i = 0; i<DISTANCE_SENSOR_N; i++) {
    Serial.print("Filtered distance sensor");
    Serial.print(i+1);
    Serial.print(": ");
    Serial.println(tof_FIR_filtered[i]);
  }

  int actuator = 0;
  testPid(tof_FIR_filtered, actuator);

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

  steerMotors();

  if (stopAll) {
    roboclaw.ForwardBackwardM1(address1, 64);
    roboclaw.ForwardBackwardM2(address1, 64);
  }
   

// Prints value of load cells after adjusting for offset
  /*
  Serial.println("Scale1 measurements");
  Serial.println(scale1.get_units()+offset[0]); 
  
  Serial.println("Scale2 measurements");
  Serial.println(scale2.get_units()+offset[0]);

  Serial.println("Scale3 measurements");
  Serial.println(scale3.get_units()+offset[0]); 

  Serial.println("Scale4 measurements");
  Serial.println(scale4.get_units()+offset[0]);

  Serial.println("Scale5 measurements");
  Serial.println(scale5.get_units()+offset[0]);
*/
/*  Serial.println("Scale6 measurements");
  Serial.println(scale6.get_units()+offset[0]);

  Serial.println("Scale7 measurements");
  Serial.println(scale7.get_units()+offset[0]);
  */
  while((millis() - prev_time) < dt_millis) {}
  Serial.println("");
}

void firFilter(float output[]) {
  for (int k=0;k<DISTANCE_SENSOR_N;k++) {
    output[k] = 0;
    for (int i = 0; i < FIR_N; i++) {
        output[k] += FIR_COEFFS[i] * buffer[k][i];
    }
  }
}

void updateBuffer(float input[]) {
    for (int k = 0; k < DISTANCE_SENSOR_N; k++) {
      for (int i = FIR_N-1; i > 0; i--) {
        buffer[k][i] = buffer[k][i-1];
      }
      buffer[k][0] = input[k];
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
    Serial.print("Connecting to sensor: ");
    Serial.println(i+1);
    
    /*while(!lox[i].begin(TOF_ADDRESSES[i])) {
      Serial.print(F("Failed to boot Sensor: "));
      Serial.println({i+1});
      delay(1000);
    }
    */
    delay(10);
  }
}


void steerMotors() {
  if (stopAll) { 
    for (int i=0;i<N_ACTUATORS;i++) { u[i] = 64; }  // Set all motors to stop (64)
  }
  roboclaw.ForwardBackwardM1(address1, u[0]);
  /*
  roboclaw.ForwardBackwardM2(address1, u[1]);
  roboclaw.ForwardBackwardM1(address2, u[2]);
  roboclaw.ForwardBackwardM2(address2, u[3]);
  roboclaw.ForwardBackwardM1(address3, u[4]);
  roboclaw.ForwardBackwardM2(address3, u[5]);
  roboclaw.ForwardBackwardM1(address4, u[6]);
  */
}


// GPT GENERATED: 
void serialEvent() {
  while (Serial.available() && !string_complete) {
    char inChar = (char)Serial.read();
    simulink_string += inChar;

    if (inChar == '\n') {
      string_complete = true;
      //Serial.println(simulink_string);
    }
  }
  string_complete = false;
}

void parseData(String data) {
  Serial.println(data);
  data.trim();

    if (data.startsWith("<") && data.endsWith(">")) {
    Serial.println("Her no");

    data.remove(0, 1);              // remove '<'
    data.remove(data.length()-2);   // remove '>\n'

    int index = 0;
    char *token = strtok((char*)data.c_str(), ",");

    while (token != NULL && index < 7) {
      set_values[index++] = atoi(token);
      token = strtok(NULL, ",");
    }
  }
  //simulink_string = "";
}
