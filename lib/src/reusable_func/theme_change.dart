import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> themeChange() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode;

  if (Get.isDarkMode) {
    isDarkMode = false;
    Get.changeThemeMode(ThemeMode.light);
  } else {
    isDarkMode = true;
    Get.changeThemeMode(ThemeMode.dark);
  }
  await prefs.setBool('isDarkMode', isDarkMode);
}

class ThemeGetter {
  isDarkMode() {
    return Get.isDarkMode;
  }
}
