#include <SoftwareSerial.h>
#include <HX711.h>

const int N_LOADING_CELLS = 7;

HX711 scales[N_LOADING_CELLS];
const int DOUT[N_LOADING_CELLS] = {3, 5, 7, 9, 11, 13, 15};
const int CLK[N_LOADING_CELLS] = {2, 4, 6, 8, 10, 12, 14};
char scale_buffer[52];
char scale_temp[7][15];
int load_cell_value[N_LOADING_CELLS];
int offset[7] = {0};

// Time tracking
unsigned long dt_millis = 10; //milliseconds
unsigned long prev_time = millis();

void setup() {
  Serial.begin(460800);
  // wait until serial port opens for native USB devices
  while (! Serial) {
    delay(1);
  }

  for (int i = 0; i < N_LOADING_CELLS; i++) {
    scales[i].begin(DOUT[i], CLK[i]);
    scales[i].set_scale(14);
  }
}

void loop() {
  /*
  Serial.println(scales[0].get_units());
  Serial.println(scales[1].get_units());
  Serial.println(scales[2].get_units());
  Serial.println(scales[3].get_units());
  Serial.println(scales[4].get_units());
  Serial.println(scales[5].get_units());
  Serial.println(scales[6].get_units());
  */
  
  for (int i = 0; i < N_LOADING_CELLS; i++) {
    load_cell_value[i] = scales[i].get_units() + offset[i];
    dtostrf(load_cell_value[i], 6, 0, scale_temp[i]); //Make string of load cell measurements
  }
  

  snprintf(scale_buffer, sizeof(scale_buffer),
         "<%s,%s,%s,%s,%s,%s,%s>\n",
         scale_temp[0], scale_temp[1], scale_temp[2],
         scale_temp[3], scale_temp[4], scale_temp[5], scale_temp[6]);
  
  Serial.print(scale_buffer);
  
  while((millis() - prev_time) < dt_millis) {}
}
