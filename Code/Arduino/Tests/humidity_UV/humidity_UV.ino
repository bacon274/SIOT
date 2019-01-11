#include <Arduino.h>
#include <Wire.h>
#include "Adafruit_VEML6075.h"
#include "Adafruit_SHT31.h"

Adafruit_SHT31 sht31 = Adafruit_SHT31();
Adafruit_VEML6075 uv = Adafruit_VEML6075();

void setup() {
  Serial.begin(9600);
  Serial.println("Humidity and UV Light Test");
  
  if (! sht31.begin(0x44)) {   // Set to 0x45 for alternate i2c addr
    Serial.println("Couldn't find SHT31");
    while (1) delay(1);
  }
    
  if (! uv.begin(0x45)) {
    Serial.println("Failed to communicate with VEML6075 sensor, check wiring?");
  }
  
  Serial.println("Found VEML6075 sensor");
   
}

void loop() {
  
  float h = sht31.readHumidity();
  
  float u = uv.readUVI();

  Serial.println("Humidity %:");
  Serial.println(h);
  Serial.println("UV Light index");
  Serial.println(u);
  delay(1000);
}
