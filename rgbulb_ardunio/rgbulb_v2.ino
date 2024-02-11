#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <EEPROM.h>
#define kirmizi D5
#define yesil D6
#define mavi D7

// ----------------------------------------------- VARIABLES
const char* ESP_ssid = "RGBulb_Wi-Fi";
const char* ESP_password = "00000000";
IPAddress ESP_ip;

char* WiFi_ssid /*= "SUPERONLINE_Wi-Fi_1502"*/;
char* WiFi_password /*= "KUsNKZkshy4D"*/;

String htmlNetworks;

bool connecting = false;

ESP8266WebServer server(80);

// ----------------------------------------------- FUNCTION DECLARATIONS
void getEepromData();
void connectToWifi(char*, char*);
void scanAllNetworks();
void setupAP();
void handleSelectNetwork();
void handleNotFound();
String selectNetworkPage();

// ----------------------------------------------- SETUP
void setup() {
  pinMode(kirmizi, OUTPUT); // Set RGB-LED's R pin
  pinMode(yesil, OUTPUT); // Set RGB-LED's G pin
  pinMode(mavi, OUTPUT); // Set RGB-LED's B pin
  pinMode(LED_BUILTIN, OUTPUT); // Set built-in LED pin
  digitalWrite(LED_BUILTIN, HIGH);
  
  Serial.begin(115200);
  //WiFi.disconnect();
  //EEPROM.begin(512);
  delay(100);

  WiFi.mode(WIFI_AP);
  WiFi.softAP(ESP_ssid, ESP_password);
  server.on("/", handleSelectNetwork);

//  Serial.println("");
//  getEepromData(); // get saved Wi-Fi's data
//  connecting = true; // connect to Wi-Fi
}

// ----------------------------------------------- LOOP
void loop() {
  server.handleClient();
}

//void loop() {
//  if (WiFi.status() != WL_CONNECTED) {
//    if (connecting) {
//      connectToWifi(WiFi_ssid, WiFi_password);
//      connecting = false;
//    } else {
//      scanAllNetworks();
//      setupAP();
//      while (!connecting) {
//        server.handleClient();
//        digitalWrite(LED_BUILTIN, LOW);
//        delay(1500);
//        digitalWrite(LED_BUILTIN, HIGH);
//        delay(1500);
//      }
//    }
//  } else {
//    digitalWrite(LED_BUILTIN, LOW);
//  }
//}

// ----------------------------------------------- WIFI
void getEepromData() {
  String savedSsid;
  String savedPassword;
  
  Serial.println("---");
  for (int i = 0; i < 32; ++i) {
    savedSsid += char(EEPROM.read(i));
  }
  Serial.print("Current Wi-Fi Name: ");
  Serial.println(savedSsid);

  for (int i = 32; i < 96; ++i)
  {
    savedPassword += char(EEPROM.read(i));
  }
  Serial.print("Current Wi-Fi Password: ");
  Serial.println(savedPassword);
}

void connectToWifi(char* ssid, char* password) {
  int i=0;
  Serial.println("---");
  Serial.print("Connecting to Wi-Fi");
  WiFi.mode(WIFI_STA);
  while (WiFi.status() != WL_CONNECTED && i<10) {
    WiFi.begin(ssid, password);
    i++;
    digitalWrite(LED_BUILTIN, LOW);
    delay(100);
    digitalWrite(LED_BUILTIN, HIGH);
    delay(200);
    digitalWrite(LED_BUILTIN, LOW);
    delay(100);
    digitalWrite(LED_BUILTIN, HIGH);
    delay(600);
    Serial.print(".");
    delay(1000);
    Serial.print(".");
  }
  Serial.println("");
  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("Connected to Wi-Fi!");
    digitalWrite(LED_BUILTIN, LOW);
    delay(100);
    digitalWrite(LED_BUILTIN, HIGH);
    delay(200);
    digitalWrite(LED_BUILTIN, LOW);
    delay(100);
    digitalWrite(LED_BUILTIN, HIGH);
    delay(200);
    digitalWrite(LED_BUILTIN, LOW);
    delay(100);
    digitalWrite(LED_BUILTIN, HIGH);
  } else {
    Serial.println("Not connected to Wi-Fi");
  }
}

void scanAllNetworks() {
  WiFi.disconnect();
  delay(100);
  
  WiFi.mode(WIFI_STA);
  int n = WiFi.scanNetworks();
  Serial.println("---");
  Serial.print("Scanned Networks: ");
  Serial.println(n);
  
  htmlNetworks = "<ol>";
  for (int i = 0; i < n; ++i) {
    // Print SSID and RSSI for each network found
    htmlNetworks += "<li>";
    htmlNetworks += WiFi.SSID(i);
    htmlNetworks += " (";
    htmlNetworks += WiFi.RSSI(i);

    htmlNetworks += ")";
    htmlNetworks += (WiFi.encryptionType(i) == ENC_TYPE_NONE) ? " " : "*";
    htmlNetworks += "</li>";
  }
  htmlNetworks += "</ol>";
  delay(100);
}

// ----------------------------------------------- WEB SERVER AND WEBSITE
void setupAP() {
  Serial.println("---");
  Serial.println("Starting Access Point...");
  WiFi.mode(WIFI_AP);
  WiFi.softAP(ESP_ssid, ESP_password);
  // All pages and routes down below
  server.on("/", handleSelectNetwork);
  server.onNotFound(handleNotFound);
  
  ESP_ip = WiFi.softAPIP();
  Serial.print("HTML Page: http://");
  Serial.println(ESP_ip);
}

void handleSelectNetwork() {
  server.send(200, "text/plain", "THIS IS A PAGE!");
}

void handleNotFound() {
  server.send(200, "text/plain", "Page not found");
}

String selectNeworkPage() {
  String htmlContent;
  String ip = String(ESP_ip[0]) + '.' + String(ESP_ip[1]) + '.' + String(ESP_ip[2]) + '.' + String(ESP_ip[3]);
  htmlContent = "<!DOCTYPE HTML>";
  htmlContent += "<html>";
  htmlContent += "<head>";
  htmlContent += "<title>RGBulb</title>";
  htmlContent += "</head>";
  htmlContent += "<body>";
  htmlContent += "<h1>RGBulb</h1><br>";
  htmlContent += "<h3>All Detected Networks</h3><br>";
  htmlContent += ip;
  htmlContent += "<p>";
  htmlContent += htmlNetworks;
  htmlContent += "</p>";
  htmlContent += "<form method='get' action='setting'>";
  htmlContent += "<label>SSID: </label><input name='ssid' length=32>";
  htmlContent += "<label>PASS: </label><input name='pass' length=64><input type='submit'>";
  htmlContent += "</form>";
  htmlContent += "<body>";
  htmlContent += "</html>";
  return htmlContent;
}

// ----------------------------------------------- MESSAGE
void msgCheck() {
//  ok1 = strchr(payload2, str3); // Check that { exist on string
//  ok2 = strchr(payload2, str4); // Check that } exist on string
//  if (ok1 != NULL && ok2 != NULL) //Checks char has { and }, i do this because i will send different kind of messages using { and } to indicate one type.
//  {
//    token = strtok(payload2, del);
//    int i = 0;
//    while ( token != NULL )
//    {
//      array[i++] = token;
//      token = strtok(NULL, del);
//    }
//  }
//
//  int r = atoi(array[0]);
//  int g = atoi(array[1]);
//  int b = atoi(array[2]);
//  RGB_color(r, g, b);
}

void RGB_color(int red_light_value, int green_light_value, int blue_light_value)
{
  analogWrite(kirmizi, red_light_value);
  analogWrite(yesil, green_light_value);
  analogWrite(mavi, blue_light_value);
}
