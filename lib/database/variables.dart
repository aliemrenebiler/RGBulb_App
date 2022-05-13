import 'dart:async';
import 'package:flutter/material.dart';

StreamController<bool> connectionController =
    StreamController<bool>.broadcast();
Stream<bool> connectionStream = connectionController.stream;

StreamController<bool> statusController = StreamController<bool>.broadcast();
Stream<bool> statusStream = statusController.stream;

// create some values
Color pickerColor = const Color(0xffffffff);
Color currentColor = const Color(0xffffffff);

StreamController<Color> colorController = StreamController<Color>.broadcast();
Stream<Color> colorStream = colorController.stream;
