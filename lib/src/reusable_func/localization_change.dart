import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> localizationChange() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Locale newLocale;

  if (Get.locale == const Locale('en', '')) {
    newLocale = const Locale('id', '');
  } else if (Get.locale == const Locale('id', '')) {
    newLocale = const Locale('en', '');
  } else {
    newLocale = const Locale('id', '');
  }

  Get.updateLocale(newLocale);
  await prefs.setString('locale', newLocale.toLanguageTag());
  // print(newLocale);
}
