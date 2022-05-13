import 'dart:async';
import 'package:flutter/material.dart';

StreamController<bool> connectionController =
    StreamController<bool>.broadcast();
Stream<bool> connectionStream = connectionController.stream;

StreamController<bool> statusController = StreamController<bool>.broadcast();
Stream<bool> statusStream = statusController.stream;

// create some values
Color pickerColor = Color(0xff443a49);
Color currentColor = Color(0xff443a49);

StreamController<Color> colorController = StreamController<Color>.broadcast();
Stream<Color> colorStream = colorController.stream;
