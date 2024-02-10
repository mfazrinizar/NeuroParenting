import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ThemeClass {
  Color lightPrimaryColor = HexColor('#4173CA');
  Color darkPrimaryColor = HexColor('#031525');
  Color secondaryColor = HexColor('#FF8B6A');
  Color accentColor = HexColor('#FFD2BB');
  Color darkRounded = HexColor('#162c46');

  static ThemeData lightTheme = ThemeData(
    primaryColor: ThemeData.light().scaffoldBackgroundColor,
    primaryColorLight: _themeClass.lightPrimaryColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _themeClass.lightPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),
    colorScheme: const ColorScheme.light().copyWith(
        primary: _themeClass.lightPrimaryColor,
        secondary: _themeClass.secondaryColor),
    dialogBackgroundColor: Colors.white,
  );

  static ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(backgroundColor: _themeClass.darkRounded),
    scaffoldBackgroundColor: const Color.fromARGB(255, 3, 21, 37),
    primaryColor: ThemeData.dark().scaffoldBackgroundColor,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: _themeClass.darkPrimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    ),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themeClass.darkPrimaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: HexColor('#C30101'),
        ),
      ),
      errorStyle: TextStyle(
        color: HexColor('#C30101'),
      ),
    ),
    dialogBackgroundColor: const Color.fromARGB(255, 3, 21, 37),
  );
}

ThemeClass _themeClass = ThemeClass();
