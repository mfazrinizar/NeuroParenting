import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;
  }
}

// Height of the screen size
double getScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;

  return (inputHeight / 812.0) * screenHeight;
}

// Width of the screen size
double getScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;

  return (inputWidth / 375.0) * screenWidth;
}

double getRelativeHeight(double percentage) {
  return percentage * SizeConfig.screenHeight;
}

double getRelativeWidth(double percentage) {
  return percentage * SizeConfig.screenWidth;
}
