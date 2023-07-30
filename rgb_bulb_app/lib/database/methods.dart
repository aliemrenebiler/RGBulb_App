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

turnOnBulb() async {
  pickerColor = const Color(0xffffffff);
  mqtt.sendMessage(
      '{${pickerColor.red},${pickerColor.green},${pickerColor.blue}}');
  onOffController.add(true);
}

turnOffBulb() async {
  pickerColor = const Color(0xff000000);
  mqtt.sendMessage(
      '{${pickerColor.red},${pickerColor.green},${pickerColor.blue}}');
  onOffController.add(false);
}

changeColor(Color color) async {
  pickerColor = color;
  mqtt.sendMessage('{${color.red},${color.green},${color.blue}}');
}
