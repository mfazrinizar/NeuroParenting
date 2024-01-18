// main.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:neuroparenting/src/homepage.dart';
import 'package:neuroparenting/src/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';
import 'src/localization/app_localizations_delegate.dart';
import 'src/pages/onboarding/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Gemini.init(apiKey: 'AIzaSyDDgqJGmvuFC81Uzx2zuphJusDmlpsvsQk');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  String _locale = 'en';
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    // print(Get.locale);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? localeString = prefs.getString('locale');
    bool isDarkMode = prefs.getBool('isDarkMode') ?? false;

    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
      _locale = localeString ?? 'en';
      Get.updateLocale(Locale(_locale, ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'NeuroParenting',
      theme: ThemeClass.lightTheme,
      darkTheme: ThemeClass.darkTheme,
      themeMode: _themeMode,
      locale: Locale(_locale, ''),
      builder: EasyLoading.init(),
      home: FirebaseAuth.instance.currentUser != null
          ? const HomePage()
          : const OnboardingScreen(),
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
