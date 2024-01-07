import 'package:flutter/material.dart';

Color invert(Color color) {
  final red = 255 - color.red;
  final green = 255 - color.green;
  final blue = 255 - color.blue;

  return Color.fromARGB((color.opacity * 255).round(), red, green, blue);
}
