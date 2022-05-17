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

changeColor(Color color) async {
  pickerColor = color;
  mqtt.sendMessage('${color.red},${color.green},${color.blue}');
}
