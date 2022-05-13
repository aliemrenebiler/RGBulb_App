import 'package:flutter/material.dart';

import 'variables.dart';

Future connectToBulb() async {
  // Try to connect

  // If connected, connection control is true
  if (true) {
    connectionController.add(true);
  } else {
    connectionController.add(false);
  }
  // Get the bulb status (open/close)
  statusController.add(false);
}

Future disconnectFromBulb() async {
  // Try to connect

  // If disconnected, status is false
  if (true) {
    connectionController.add(false);
  } else {
    connectionController.add(true);
  }
}

Future turnOnBulb() async {
  // Try to connect

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

changeColor(Color color) {
  pickerColor = color;
  print(color);
}
