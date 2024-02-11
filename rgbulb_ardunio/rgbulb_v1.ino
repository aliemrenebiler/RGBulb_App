#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#define kirmizi D5
#define yesil D6
#define mavi D7

// Update these with values suitable for your network.
#define mqtt_port 1883
#define MQTT_USER "digital"
#define MQTT_PASSWORD "ceeeks"
#define MQTT_SERIAL_RECEIVER_CH "bulb"
const char* ssid = "SUPERONLINE_Wi-Fi_1502";
const char* password = "KUsNKZkshy4D";
const char* mqtt_server = "broker.mqttdashboard.com";

char *token,*ok1,*ok2; 
const char str3 = '{';
const char str4 = '}';
const char del[] = "{},";
char *array[3];

WiFiClient wifiClient;

PubSubClient client(wifiClient);

void setup_wifi() {
    delay(10);
    // We start by connecting to a WiFi network
    Serial.println();
    Serial.print("Connecting to ");
    Serial.println(ssid);
    WiFi.begin(ssid, password);
    while (WiFi.status() != WL_CONNECTED) {
      delay(500);
      Serial.print(".");
    }
    randomSeed(micros());
    Serial.println("");
    Serial.println("WiFi connected");
    Serial.println("IP address: ");
    Serial.println(WiFi.localIP());
}

void reconnect() {
  // Loop until we're reconnected
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    // Create a random client ID
    String clientId = "NodeMCUClient-";
    clientId += String(random(0xffff), HEX);
    // Attempt to connect
    if (client.connect(clientId.c_str(),MQTT_USER,MQTT_PASSWORD)) {
      Serial.println("connected");
      // ... and resubscribe
      client.subscribe(MQTT_SERIAL_RECEIVER_CH);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      // Wait 5 seconds before retrying
      delay(5000);
    }
  }
}


void callback(char* topic, byte *payload, unsigned int length) {
    Serial.write(payload, length);
    Serial.println();
    char *payload2 = (char *)payload;
    ok1=strchr(payload2, str3); // Check that { exist on string
    ok2=strchr(payload2, str4); // Check that } exist on string
    if (ok1!=NULL && ok2!=NULL) //Checks char has { and }, i do this because i will send different kind of messages using { and } to indicate one type.
    {
      token = strtok(payload2, del);
      int i=0;
      while( token != NULL ) 
      {
        array[i++] = token;
        token = strtok(NULL, del);
        }
    }
    
    int r = atoi(array[0]);
    int g = atoi(array[1]);
    int b = atoi(array[2]);
    RGB_color(r,g,b);
}

void RGB_color(int red_light_value, int green_light_value, int blue_light_value)
 {
  analogWrite(kirmizi, red_light_value);
  analogWrite(yesil, green_light_value);
  analogWrite(mavi, blue_light_value);
}

void setup() {
  pinMode(kirmizi,OUTPUT);
  pinMode(yesil,OUTPUT);
  pinMode(mavi,OUTPUT);
  Serial.begin(115200);
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
  reconnect();
}

void loop() {
   client.loop();
 }
