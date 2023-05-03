#include <OneWire.h>
#include <DallasTemperature.h>
#include <TFT_eSPI.h> // Graphics and font library for ILI9341 driver chip
#include <SPI.h>
#include "WiFi.h"
#include "time.h"
//#include <driver/i2s.h>

/*#define I2S_WS 35
#define I2S_SD 33
#define I2S_SCK 12
#define I2S_PORT I2S_NUM_0
#define bufferLen 64
int16_t sBuffer[bufferLen];*/

//Temperature
const int Temp_Bus = 5;
OneWire oneWire(Temp_Bus);
DallasTemperature sensors(&oneWire);

//Water flow
#define LED_BUILTIN 2
#define SENSOR  16

long currentMillis = 0;
long previousMillis = 0;
int interval = 1000;
boolean ledState = LOW;
float calibrationFactor = 4.5;
volatile byte pulseCount;
byte pulse1Sec = 0;
float flowRate;
unsigned int flowMilliLitres;
unsigned long totalMilliLitres;

//LCD
#define TFT_GREY 0x5AEB // New colour
// Size of sprite image for the scrolling text, this requires ~14 Kbytes of RAM
#define IWIDTH  290
#define IHEIGHT 30
#define WAIT 0

//WIFI
#define WIFI_NETWORK  "Angelo"
#define WIFI_PASSWORD  "Nolasco10"
#define WIFI_TIMEOUT_MS 20000


//TIME
const char* ntpServer = "pool.ntp.org";
const long  gmtOffset_sec = 14400;
const int   daylightOffset_sec = 3600;

//LCD
TFT_eSPI tft = TFT_eSPI();  // Invoke library
TFT_eSprite img = TFT_eSprite(&tft);  // Create Sprite object "img" with pointer to "tft" object
                                    // the pointer is used by pushSprite() to push it onto the TFT

uint32_t targetTime = 0;   // for next 1 second timeout

/*
 *  Get H,M, S after ntp server connected, 
 *  will load in printLocalTime()
 */
uint8_t hh,mm,ss;


byte omm = 99, oss = 99;
byte xcolon = 0, xsecs = 0;
unsigned int colour = 0;





void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  
 
  delay(1000);
  connectToWiFi();

  // Init and get the time
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  printLocalTime();

 
  Init();


  //disconnect WiFi as it's no longer needed
  WiFi.disconnect(true);
  WiFi.mode(WIFI_OFF);

  LCDinti();

 
  targetTime = millis() + 1000;
 



}

void loop() {
 
  digitalTime();

  
  // put your main code here, to run repeatedly:  
  /*size_t bytesIn = 0;
  esp_err_t result = i2s_read(I2S_PORT, &sBuffer, bufferLen, &bytesIn, portMAX_DELAY);
  if (result == ESP_OK)
  {
    int samples_read = bytesIn / 8;
    if (samples_read > 0) {
      float mean = 0;
      for (int i = 0; i < samples_read; ++i) {
        mean += (sBuffer[i]);
      }
      mean /= samples_read;
      Serial.println(mean);
    }
  }*/
  
  
    
  
  // Set colour depth of Sprite to 8 (or 16) bits
  img.setColorDepth(16);
    
  // Create the sprite and clear background to black
  img.createSprite(IWIDTH, IHEIGHT);
  //Temperature
  sensors.requestTemperatures();
  float tempF = sensors.getTempFByIndex(0);


  waterFlow();


  for (int pos = IWIDTH; pos > 0; pos--)
  {
    
    build_banner("Temperature: ", pos,tempF, "F");
    img.pushSprite(0, 100);
    build_banner("Water Flow: ", pos,(totalMilliLitres * .000264172), "Gal");
    img.pushSprite(0, 150);
     
    //delay(WAIT);
  }

  // Delete sprite to free up the memory
  img.deleteSprite();




}

void IRAM_ATTR pulseCounter()
{
  pulseCount++;
}

void connectToWiFi(){
  // Connect to Wi-Fi
  Serial.print("Connecting to ");
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_NETWORK, WIFI_PASSWORD);

  unsigned long startAttemptTime = millis();
  while (WiFi.status() != WL_CONNECTED && millis() - startAttemptTime < WIFI_TIMEOUT_MS) {
    Serial.print(".");
    delay(100);
  }

  if(WiFi.status() != WL_CONNECTED){
    Serial.println(" Failed");
  }
  else{
    Serial.print("WiFi connected.");
    Serial.println(WiFi.localIP());

  }


}

void Init(){
  

  //Serial.println("Setup I2S ...");

  //delay(1000);
  //i2s_install();
  //i2s_setpin();
  //i2s_start(I2S_PORT);
  //delay(500);
 // tft.setCursor(0,-4);
  //printLocalTime();
  //delay(2000);



  //Water
  pinMode(LED_BUILTIN, OUTPUT);
  pinMode(SENSOR, INPUT_PULLUP);
  pulseCount = 0;
  flowRate = 0.0;
  flowMilliLitres = 0;
  totalMilliLitres = 0;
  previousMillis = 0;
  attachInterrupt(digitalPinToInterrupt(SENSOR), pulseCounter, FALLING);

  //Temperature
  sensors.begin();

}

void LCDinti(){
   //LCD
  tft.init();
  tft.setRotation(1);
  tft.fillScreen(TFT_WHITE);
 // Set the font colour to be white with a black background, set text size multiplier to 1
  tft.setTextColor(TFT_BLACK,TFT_WHITE); 
  tft.setTextSize(1);
  tft.println("Smart Shower");


}


// #########################################################################
// Build the scrolling sprite image from scratch, draw text at x = xpos
// #########################################################################

void build_banner(String msg, int xpos, double value,String msg2)
{
  int h = IHEIGHT;

  // We could just use fillSprite(color) but lets be a bit more creative...

  // Fill with rainbow stripes
  while (h--) img.drawFastHLine(0, h, IWIDTH, TFT_YELLOW);

  // Draw some graphics, the text will appear to scroll over these
  img.fillRect  (IWIDTH / 2 - 20, IHEIGHT / 2 - 10, 40, 20, TFT_YELLOW);
  img.fillCircle(IWIDTH / 2, IHEIGHT / 2, 10, TFT_YELLOW);

  // Now print text on top of the graphics
  img.setTextSize(1);           // Font size scaling is x1
  img.setTextFont(4);           // Font 4 selected
  img.setTextColor(TFT_BLACK);  // Black text, no background colour
  img.setTextWrap(false);       // Turn of wrap so we can print past end of sprite

  // Need to print twice so text appears to wrap around at left and right edges
  img.setCursor(xpos, 2);  // Print text at xpos
  img.print(msg);
  img.print(value);
  img.print(msg2);

  img.setCursor(xpos - IWIDTH, 2); // Print text at xpos - sprite width
  img.print(msg);
  img.print(value);
  img.print(msg2);
}

void printLocalTime(){
  struct tm timeinfo;
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
    return;
  }


  
  tft.println(&timeinfo, "%I:%M:%S");
  int time_hr   = timeinfo.tm_hour;
  int time_min  = timeinfo.tm_min;
  int time_sec  = timeinfo.tm_sec;

  Serial.println("tm_hr:   " + String(time_hr));
  Serial.println("tm_min:  " + String(time_min));
  Serial.println("tm_sec:  " + String(time_sec)); 
  hh = time_hr;
  mm = time_min;
  ss = time_sec;
  

}

void digitalTime(){
    if (targetTime < millis()) {
    // Set next update for 1 second later
    targetTime = millis() + 1000;

    // Adjust the time values by adding 1 second
    ss++;              // Advance second
    if (ss == 60) {    // Check for roll-over
      ss = 0;          // Reset seconds to zero
      omm = mm;        // Save last minute time for display update
      mm++;            // Advance minute
      if (mm > 59) {   // Check for roll-over
        mm = 0;
        hh++;          // Advance hour
        if (hh > 23) { // Check for 24hr roll-over (could roll-over on 13)
          hh = 0;      // 0 for 24 hour clock, set to 1 for 12 hour clock
        }
      }
    }


    // Update digital time
    int xpos = 0;
    int ypos = 45; // Top left corner ot clock text, about half way down
    int ysecs = ypos;

    if (omm != mm) { // Redraw hours and minutes time every minute
      omm = mm;
      // Draw hours and minutes
      if (hh < 10) xpos += tft.drawChar('0', xpos, ypos, 6); // Add hours leading zero for 24 hr clock
      xpos += tft.drawNumber(hh, xpos, ypos, 6);             // Draw hours
      xcolon = xpos; // Save colon coord for later to flash on/off later
      xpos += tft.drawChar(':', xpos, ypos - 6, 6);
      if (mm < 10) xpos += tft.drawChar('0', xpos, ypos, 6); // Add minutes leading zero
      xpos += tft.drawNumber(mm, xpos, ypos, 6);             // Draw minutes
      xsecs = xpos; // Sae seconds 'x' position for later display updates
    }
    if (oss != ss) { // Redraw seconds time every second
      oss = ss;
      xpos = xsecs;

      if (ss % 2) { // Flash the colons on/off
        tft.setTextColor(TFT_BLACK, TFT_WHITE);        // Set colour to grey to dim colon
        tft.drawChar(':', xcolon, ypos - 6, 6);     // Hour:minute colon
        xpos += tft.drawChar(':', xsecs, ysecs, 4); // Seconds colon
        tft.setTextColor(TFT_BLACK, TFT_WHITE);    // Set colour back to yellow
      }
      else {
        tft.drawChar(':', xcolon, ypos - 6, 6);     // Hour:minute colon
        xpos += tft.drawChar(':', xsecs, ysecs, 4); // Seconds colon
      }

      //Draw seconds
      if (ss < 10) xpos += tft.drawChar('0', xpos, ysecs, 6); // Add leading zero
      tft.drawNumber(ss, xpos, ysecs, 6);                     // Draw seconds
    }
  }

}

void waterFlow(){
  //Water
    currentMillis = millis();
    if (currentMillis - previousMillis > interval) {
      
      pulse1Sec = pulseCount;
      pulseCount = 0;

      // Because this loop may not complete in exactly 1 second intervals we calculate
      // the number of milliseconds that have passed since the last execution and use
      // that to scale the output. We also apply the calibrationFactor to scale the output
      // based on the number of pulses per second per units of measure (litres/minute in
      // this case) coming from the sensor.
      flowRate = ((1000.0 / (millis() - previousMillis)) * pulse1Sec) / calibrationFactor;
      previousMillis = millis();

      // Divide the flow rate in litres/minute by 60 to determine how many litres have
      // passed through the sensor in this 1 second interval, then multiply by 1000 to
      // convert to millilitres.
      flowMilliLitres = (flowRate / 60) * 1000;

      // Add the millilitres passed in this second to the cumulative total
      totalMilliLitres += flowMilliLitres;
      
      // Print the flow rate for this second in litres / minute
      Serial.print("Flow rate: ");
      Serial.print(int(flowRate));  // Print the integer part of the variable
      Serial.print("L/min");
      Serial.print("\t");       // Print tab space

      // Print the cumulative total of litres flowed since starting
      Serial.print("Output Liquid Quantity: ");
      Serial.print(totalMilliLitres);
      Serial.print("mL / ");
      Serial.print(totalMilliLitres * .000264172);
      Serial.println("Gal");
    }
}


/*void i2s_install(){
  const i2s_config_t i2s_config = {
    .mode = i2s_mode_t(I2S_MODE_MASTER | I2S_MODE_RX),
    .sample_rate = 44100,
    .bits_per_sample = i2s_bits_per_sample_t(16),
    .channel_format = I2S_CHANNEL_FMT_ONLY_LEFT,
    .communication_format = i2s_comm_format_t(I2S_COMM_FORMAT_STAND_I2S),
    .intr_alloc_flags = 0, // default interrupt priority
    .dma_buf_count = 8,
    .dma_buf_len = bufferLen,
    .use_apll = false
  };

  i2s_driver_install(I2S_PORT, &i2s_config, 0, NULL);
}

void i2s_setpin(){
  const i2s_pin_config_t pin_config = {
    .bck_io_num = I2S_SCK,
    .ws_io_num = I2S_WS,
    .data_out_num = -1,
    .data_in_num = I2S_SD
  };

  i2s_set_pin(I2S_PORT, &pin_config);
}*/




