import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'src/pages/onboarding/onboarding_screen.dart';
import 'src/localization/app_localizations_delegate.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: const MaterialColor(0xFF4173CA, {
          50: Color.fromRGBO(65, 115, 202, .1),
          100: Color.fromRGBO(65, 115, 202, .2),
          200: Color.fromRGBO(65, 115, 202, .3),
          300: Color.fromRGBO(65, 115, 202, .4),
          400: Color.fromRGBO(65, 115, 202, .5),
          500: Color.fromRGBO(65, 115, 202, .6),
          600: Color.fromRGBO(65, 115, 202, .7),
          700: Color.fromRGBO(65, 115, 202, .8),
          800: Color.fromRGBO(65, 115, 202, .9),
          900: Color.fromRGBO(65, 115, 202, 1),
        }),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const OnboardingScreen(),
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('id', ''), // Indonesian
      ],
    );
  }
}
