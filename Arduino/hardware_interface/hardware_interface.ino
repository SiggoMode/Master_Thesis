#include <SoftwareSerial.h>
#include <HX711.h>
#include <RoboClaw.h>
#include "Adafruit_VL53L0X.h"

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


// Roboclaw
SoftwareSerial serial(16,17); // RoboClaw communication
RoboClaw roboclaw(&serial,10000);
#define address1 0x80 // Address to RoboClaw controller
#define address2 0x81
#define address3 0x82
#define address4 0x83

bool StopAll = false;

// Load cell readings
HX711 scale1;
HX711 scale2;
HX711 scale3;
HX711 scale4;
HX711 scale5;
HX711 scale6;
HX711 scale7;

// Range sensors
Adafruit_VL53L0X lox[6] = Adafruit_VL53L0X();
//const int XSHUT[6] = {2,3,4,5,6,7};
const int XSHUT[3] = {49,51,53};
const byte TOF_ADDRESSES[6] = {0x35, 0x34, 0x33, 0x32, 0x31, 0x30};
const int DISTANCE_SENSOR_N = sizeof(XSHUT) / sizeof(XSHUT[0]);

int Load_Cell_Value[7];
int offset[1];

// Motion control
const int END_SWITCH[4] = {31, 33, 35, 37};

void setup() {
  Serial.begin(115200);
  // wait until serial port opens for native USB devices
  while (! Serial) {
    delay(1);
  }


  roboclaw.begin(38400); // Open coboclaw serial ports
  pinMode(END_SWITCH[0], INPUT);
  pinMode(END_SWITCH[1], INPUT); // Endre til for loop lol

/*
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
*/    
   offset[0] = 1015;


  for (int i = 0; i<DISTANCE_SENSOR_N; i++) {
    pinMode(XSHUT[i], OUTPUT);
    digitalWrite(XSHUT[i], LOW);
  }

  delay(10);

  for (int i = 0; i<DISTANCE_SENSOR_N; i++) {
    digitalWrite(XSHUT[i], HIGH);
  }

  delay(10);

  for (int i = 1; i<DISTANCE_SENSOR_N; i++) { // Set all except sensor 1 in offline
    digitalWrite(XSHUT[i], LOW);
  }

  delay(10);

  for (int i = 0; i<DISTANCE_SENSOR_N; i++) {
    digitalWrite(XSHUT[i], HIGH);
    Serial.print("Connecting to sensor: ");
    Serial.println(i+1);
    while(!lox[i].begin(TOF_ADDRESSES[i])) {
      Serial.print(F("Failed to boot Sensor: "));
      Serial.println({i+1});
      delay(1000);
    }
    delay(10);
  }
}

void loop() {
  if (Serial.available() > 0) { // Check for incoming stop signal
    incomingByte = Serial.read();
    if ((char)incomingByte == ' ') {
      Serial.println("Stop signal received ");
      stopAll = true;
    }
    if ((char)incomingByte == 'c') {
      Serial.println("Continue signal received");
      stopAll = false;
    }
  }


  VL53L0X_RangingMeasurementData_t measure;
  
  for (int i = 0; i<DISTANCE_SENSOR_N; i++) {
    Serial.print("Sensor reading ");
    Serial.print(i+1);
    Serial.print(": ");
    lox[i].rangingTest(&measure, false);

    if (measure.RangeStatus != 4) {  // phase failures have incorrect data
      Serial.print("Distance (mm): "); Serial.println(measure.RangeMilliMeter);
    } else {
      Serial.println(" out of range ");
    }
  }
  
  if (!stopAll) {
    
  }

  /*
  if (!digitalRead(END_SWITCH[0])) {
    /*
    roboclaw.ForwardBackwardM1(address1, 50);
    roboclaw.ForwardBackwardM2(address1, 50);
    roboclaw.ForwardBackwardM1(address2, 80);
    roboclaw.ForwardBackwardM2(address2, 50);
    roboclaw.ForwardBackwardM1(address3, 80);
    roboclaw.ForwardBackwardM2(address3, 50);
    roboclaw.ForwardBackwardM1(address4, 50);
    *//*
    //Serial.println("Forward switch detected");
    //roboclaw.ForwardBackwardM1(address2, 80);
    Serial.println("Switch 1 detected");
  }
  else {
    roboclaw.ForwardBackwardM1(address2, 64);
  }
  */
  /*
  else if (!digitalRead(END_SWITCH[1])) {
    roboclaw.ForwardBackwardM1(address1, 80);
    roboclaw.ForwardBackwardM2(address1, 80);
    roboclaw.ForwardBackwardM1(address2, 50);
    roboclaw.ForwardBackwardM2(address2, 80);
    roboclaw.ForwardBackwardM1(address3, 50);
    roboclaw.ForwardBackwardM2(address3, 80);
    roboclaw.ForwardBackwardM1(address4, 80);
    Serial.println("Backward switch detected");
  }
  else {
    roboclaw.ForwardBackwardM1(address1, 64);
    roboclaw.ForwardBackwardM2(address1, 64);
    roboclaw.ForwardBackwardM1(address2, 64);
    roboclaw.ForwardBackwardM2(address2, 64);
    roboclaw.ForwardBackwardM1(address3, 64);
    roboclaw.ForwardBackwardM2(address3, 64);
    roboclaw.ForwardBackwardM1(address4, 64);
  }
  */
  /*
  if (!digitalRead(END_SWITCH[1])) {
    Serial.println("Switch 2 detected");
  }
  if (!digitalRead(END_SWITCH[2])) {
    Serial.println("Switch 3 detected");
  }
  if (!digitalRead(END_SWITCH[3])) {
    Serial.println("Switch 4 detected");
  }*/

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
  delay(10);
  Serial.println("");
}

void reboot_TOF_sensors() {}
