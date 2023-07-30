import 'dart:async';
import 'package:flutter/material.dart';

StreamController<bool> connectionController =
    StreamController<bool>.broadcast();
Stream<bool> connectionStream = connectionController.stream;

StreamController<bool> onOffController = StreamController<bool>.broadcast();
Stream<bool> onOffStream = onOffController.stream;

Color pickerColor = const Color(0xffffffff);
Color currentColor = const Color(0xffffffff);

StreamController<Color> colorController = StreamController<Color>.broadcast();
Stream<Color> colorStream = colorController.stream;
