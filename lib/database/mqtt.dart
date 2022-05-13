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

Future<bool> connect() async {
  client = MqttServerClient(broker, "40");
  client.port = port;
  client.logging(on: true);
  client.keepAlivePeriod = 30;
  client.onDisconnected = onDisconnected;

  // connection message
  final connMessage = MqttConnectMessage()
      .authenticateAs(username, password)
      .keepAliveFor(60)
      .withWillTopic('willtopic')
      .withWillMessage('Will message')
      .startClean()
      .withWillQos(MqttQos.atMostOnce);
  client.connectionMessage = connMessage;

  //baglanilan yer burasi
  try {
    await client.connect(username, password);
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
  }

  /// The client has a change notifier object(see the Observable class) which we then listen to to get
  /// notifications of published updates to each subscribed topic.
  subscription = client.updates!.listen(onMessage);

  if (client.connectionStatus == MqttConnectionState.connected) {
    print("MQTT is connected!");
    return true;
  } else {
    return false;
  }
}

void disconnect() {
  client.disconnect();
  onDisconnected();
}

void onDisconnected() {
  print("MQTT is disconnected!");
}

void onMessage(List<MqttReceivedMessage> event) {
  final MqttPublishMessage recMess = event[0].payload as MqttPublishMessage;
  var message = recMess.payload.message.buffer.asByteData(0);
}

void subscribeToTopic(String topic) {
  if (connectionStatus == MqttConnectionState.connected) {
    client.subscribe(topic, MqttQos.atMostOnce);
  }
}

void unsubscribeFromTopic(String topic) {
  if (connectionStatus == MqttConnectionState.connected) {
    client.unsubscribe(topic);
  }
}

void sendMessage(String content) {
  final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();

  builder.addString(content);
  client.publishMessage(
    "bulb",
    MqttQos.atMostOnce,
    builder.payload!,
    retain: false,
  );
}
