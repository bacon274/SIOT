//////////////////////
// Library Includes //
//////////////////////
#include <Arduino.h>
#include <Wire.h>
#include <WiFi.h>
#include "Adafruit_VEML6075.h"
#include "Adafruit_SHT31.h"
#include <SoftwareSerial.h> 
#include <SparkFunESP8266WiFi.h>
#include "ThingSpeak.h"


// #include "secrets.h"

//////////////////////////////
// WiFi Network Definitions //
//////////////////////////////
// Replace these two character strings with the name and
// password of your WiFi network.
const char mySSID[] = "Virgins";   // "SKY49DD6"; //"VM1702183" ; // "Virgins";  // "BTHub3-6GNS"
const char myPSK[] = "Partyhouse2.0";// "MMVFDRVMRT"; // "Hw8jgjbc5tjv" ;   //"Partyhouse2.0"; // "9a427dc5ab"
ESP8266Client client;

//////////////////////////////
//      ThingSpeak Setup    //
//////////////////////////////
unsigned long myChannelNumber = "656272";
const char * myWriteAPIKey = "MAR58J5NR12RNUZ7";

//////////////////////////////
//       Sensors Set-up     //
//////////////////////////////
Adafruit_SHT31 sht31 = Adafruit_SHT31();
Adafruit_VEML6075 uv = Adafruit_VEML6075();

int randNumber = 1; // this is the toggle for field

void setup() {
  Serial.begin(9600);  // Initialize serial
  initializeESP8266(); // initializeESP8266() verifies communication with the WiFi
  connectESP8266();    // connectESP8266() connects to the defined WiFi network.
  displayConnectInfo();// displayConnectInfo prints the Shield's local IP
  
  ThingSpeak.begin(client);  // Initialize ThingSpeak
  
  if (! sht31.begin(0x44)) {   // Set to 0x45 for alternate i2c addr
    Serial.println("error");
    while (1) delay(1);
  }
  if (! uv.begin(0x45)) {
    Serial.println("error");
  }
  Serial.println("Setup complete ");
  
}

void loop() {
  int x;
  int chan;
  float h = sht31.readHumidity();
 // float u = uv.readUVI();
  float t = sht31.readTemperature();
  
  Serial.println(randNumber);
  
  char result[8];
  /*
  char tresult[8]; // Buffer big enough for 7-character float
  dtostrf(t, 6, 3, tresult);
  const char*p = tresult;

  char hresult[8]; // Buffer big enough for 7-character float
  dtostrf(h, 6, 3, hresult);
  const char*q = hresult;
  */
  
  if(randNumber == 1){
   chan = 1;
   dtostrf(t, 6, 3, result);
  }
  else{
   chan = 2;
   dtostrf(h, 6, 3, result);
  }
  
  const char*dat = result;
  
  
  x = ThingSpeak.writeField(myChannelNumber, chan, dat, myWriteAPIKey);
  Serial.println(x);
  
  if(x == 200){
    Serial.print("Channel update successful: ");
    Serial.println(chan);
    if(randNumber == 1){
      randNumber = 2;
      delay(20000); // delay(300000); // Wait 1 min to update the next field 
    }
    else{
      randNumber = 1;
      delay(300000); // delay(300000); // Wait 5 mins to update the channel again
     }
  }
  else{
    delay(20000);
  }
  
}

//////////////////////////////
//         Functions        //
//////////////////////////////

void initializeESP8266()
{
  // esp8266.begin() verifies that the ESP8266 is operational
  // and sets it up for the rest of the sketch.
  // It returns either true or false -- indicating whether
  // communication was successul or not.
  // true
  int test = esp8266.begin();
  if (test != true)
  {
    Serial.println(F("Error com ESP8266."));
    errorLoop(test);
  }
  Serial.println(F("ESP8266 Shield Present"));
}

void displayConnectInfo() {
  char connectedSSID[24];
  memset(connectedSSID, 0, 24);
  // esp8266.getAP() can be used to check which AP the
  // ESP8266 is connected to. It returns an error code.
  // The connected AP is returned by reference as a parameter.
  int retVal = esp8266.getAP(connectedSSID);
  if (retVal > 0)
  {
    Serial.print(F("Connected to: "));
    Serial.println(connectedSSID);
  }

  // esp8266.localIP returns an IPAddress variable with the
  // ESP8266's current local IP address.
  IPAddress myIP = esp8266.localIP();
  Serial.print(F("My IP: ")); Serial.println(myIP);
}

void errorLoop(int error)
{
  Serial.print(F("Error: ")); Serial.println(error);
  Serial.println(F("Looping forever."));
  for (;;)
    ;
}
void connectESP8266()
{
  // The ESP8266 can be set to one of three modes:
  //  1 - ESP8266_MODE_STA - Station only
  //  2 - ESP8266_MODE_AP - Access point only
  //  3 - ESP8266_MODE_STAAP - Station/AP combo
  // Use esp8266.getMode() to check which mode it's in:
  int retVal = esp8266.getMode();
  if (retVal != ESP8266_MODE_STA)
  { // If it's not in station mode.
    // Use esp8266.setMode([mode]) to set it to a specified
    // mode.
    retVal = esp8266.setMode(ESP8266_MODE_STA);
    if (retVal < 0)
    {
      Serial.println(F("Error setting mode."));
      errorLoop(retVal);
    }
  } 
}
    
