import 'package:flutter/material.dart';

import 'mqtt.dart' as mqtt;
import 'variables.dart';

Future connectToBulb() async {
  try {
    await mqtt.connect();

    connectionController.add(true);
  } catch (e) {
    connectionController.add(false);
  }
}

Future disconnectFromBulb() async {
  mqtt.disconnect();
  connectionController.add(false);
}

Future turnOnBulb() async {
  mqtt.sendMessage("Color(0xffffffff)");
  statusController.add(true);
}

Future turnOffBulb() async {
  mqtt.sendMessage("Color(0x00000000)");
  statusController.add(false);
}

changeColor(Color color) async {
  pickerColor = color;
  mqtt.sendMessage(color.toString()); // Color(0xff48490c)
}
