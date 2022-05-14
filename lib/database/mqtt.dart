import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

const String broker = "broker.mqttdashboard.com";

const int port = 1883;
const String username = 'digital';
const String password = 'ceeeks';
final String clientIdentifier = DateTime.now().toString();

late MqttServerClient client;
late MqttServerConnection connectionStatus;

late StreamSubscription subscription;

Future connect() async {
  client = MqttServerClient(broker, "40");
  client.port = port;
  client.logging(on: true);
  client.keepAlivePeriod = 30;
  client.onDisconnected = onDisconnected;

  // connection message
  final connMessage = MqttConnectMessage()
      .authenticateAs(username, password)
      .withWillTopic('willtopic')
      .withWillMessage('Will message')
      .startClean()
      .withWillQos(MqttQos.exactlyOnce);
  client.connectionMessage = connMessage;

  //baglanilan yer burasi
  try {
    await client.connect(username, password);
  } catch (e) {
    client.disconnect();
  }
}

void disconnect() {
  client.disconnect();
  onDisconnected();
}

void onDisconnected() {}

void sendMessage(String content) {
  final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

  builder.addString(content);
  client.publishMessage(
    "bulb",
    MqttQos.exactlyOnce,
    builder.payload!,
    retain: false,
  );
}
