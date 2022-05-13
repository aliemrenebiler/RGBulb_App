import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mqtt.dart' as mqtt;
import 'variables.dart';

Future turnOnBulb() async {
  mqtt.sendMessage("Color(0xffffffff)");
  // If disconnected, status is false
  if (true) {
    statusController.add(true);
  } else {
    statusController.add(false);
  }
}

Future turnOffBulb() async {
  // Try to connect

  // If disconnected, status is false
  if (true) {
    statusController.add(false);
  } else {
    statusController.add(true);
  }
}

changeColor(Color color) async {
  pickerColor = color;
  mqtt.sendMessage(color.toString()); // Color(0xff48490c)
  print(color);
}
