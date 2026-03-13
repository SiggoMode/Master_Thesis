#include <SoftwareSerial.h>
#include <HX711.h>
#include <RoboClaw.h>

//#define CLK1 8
//#define DOUT1 9

// Roboclaw
SoftwareSerial serial(16,17); // RoboClaw communication
RoboClaw roboclaw(&serial,10000);
#define address1 0x80 // Address to RoboClaw controller
#define address2 0x81
#define address3 0x82
#define address4 0x83

// Load cell readings
//HX711 scale1;
//int Load_Cell_Value[1];
//int offset[1];

// Motion control
const int END_SWITCH[2] = {31, 33};

void setup() {
  Serial.begin(115200);

  roboclaw.begin(38400); // Open coboclaw serial ports
  pinMode(END_SWITCH[0], INPUT);
  pinMode(END_SWITCH[1], INPUT); // Endre til for loop lol

  //scale1.begin(DOUT1, CLK1);

  // Calibrating
 // scale1.set_scale(14);
    
 // offset[0] = 1015;

}

void loop() {
  if (!digitalRead(END_SWITCH[0])) {
    roboclaw.ForwardBackwardM1(address1, 50);
    roboclaw.ForwardBackwardM2(address1, 50);
    roboclaw.ForwardBackwardM1(address2, 80);
    roboclaw.ForwardBackwardM2(address2, 50);
    roboclaw.ForwardBackwardM1(address3, 80);
    roboclaw.ForwardBackwardM2(address3, 50);
    roboclaw.ForwardBackwardM1(address4, 50);
    Serial.println("Forward switch detected");
  }
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

  //Serial.println(scale1.get_units()+offset[0]); // Prints value of load cell 1 after adjusting for offset

  delay(10);
}
