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
const char mySSID[] = "VM1702183";   // "SKY49DD6"; //"VM1702183" ; // "Virgins";
const char myPSK[] = "Hw8jgjbc5tjv"; // "MMVFDRVMRT"; // "Hw8jgjbc5tjv" ;   //"Partyhouse2.0";
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
  // put your main code here, to run repeatedly:
  float h = sht31.readHumidity();
  float u = uv.readUVI();
  float t = sht31.readTemperature();
 // t = ((t-32)*5)/9; // Convert Farenheight into Centigrade
  int n = 100;
  Serial.print("H%: ");
  Serial.println(h);
  Serial.print("UV: ");
  Serial.println(u);
  Serial.print("T: ");
  Serial.println(t);

  //ThingSpeak.setField(1, t);
  //ThingSpeak.setField(2, h);
 // ThingSpeak.setField(3, u);

  int x = ThingSpeak.writeField(myChannelNumber, 1, n, myWriteAPIKey);
  //int x = ThingSpeak.writeFields(myChannelNumber, myWriteAPIKey);
  Serial.println(x);
  if(x == 200){
    Serial.println("Channel update successful.");
  }
 
  
  delay(15000); // Wait 5 seconds to update the channel again
  
}

//////////////////////////////
//         Functions        //
//////////////////////////////

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
    
