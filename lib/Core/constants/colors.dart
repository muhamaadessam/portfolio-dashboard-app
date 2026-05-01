import 'package:flutter/material.dart';

import '../Extensions/context_extension.dart';
import 'hex_color.dart';

// const Color backgroundColor = Color(0xff282C33);
// const Color grayColor = Color(0xffABB2BF);
// const Color mainColor = Color(0xff42a5f5);

class AppColors {
  static Color mainColor = HexColor('#42a5f5');

  static Color homeBackgroundColor(BuildContext context) =>
      context.isDarkMode ? HexColor('#282C33') : Colors.white;

  static Color customBackgroundColor(BuildContext context) =>
      context.isDarkMode ? HexColor('#282C33') : HexColor('#F2F4F8');

  static Color deepBackgroundColor(BuildContext context) =>
      context.isDarkMode ? HexColor('#191D23') : HexColor('#f1f1f1');

  static Color appBarColor(BuildContext context) =>
      context.isDarkMode ? HexColor('#191D23') : Colors.white;

  static Color containerBackgroundColor(BuildContext context) =>
      context.isDarkMode ? HexColor('#191D23') : Colors.white;

  static Color orderProductColor = HexColor('#33a9ff');

  static Color textColor = Colors.black;
  static Color secondTextColor = HexColor('#ABB2BF');
  static Color borderColor = Colors.black.withValues(alpha: .25);

  static Color reverseTextColor(BuildContext context) =>
      context.isDarkMode ? Colors.white : Colors.black;
  static Color errorColor = Colors.red;
}

ThemeData darkMode() => ThemeData(
  useMaterial3: false,
  brightness: Brightness.dark,
  colorSchemeSeed: HexColor('#42a5f5').withValues(alpha: .8),
  scaffoldBackgroundColor: HexColor('#282C33'),
  appBarTheme: AppBarTheme(backgroundColor: HexColor('#191D23'), elevation: 0),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: HexColor('#191D23'),
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.white),
    displayMedium: TextStyle(color: Colors.white),
    displaySmall: TextStyle(color: Colors.white),
    headlineLarge: TextStyle(color: Colors.white),
    headlineMedium: TextStyle(color: Colors.white),
    headlineSmall: TextStyle(color: Colors.white),
    titleLarge: TextStyle(color: Colors.white),
    titleMedium: TextStyle(color: Colors.white),
    titleSmall: TextStyle(color: Colors.white),
    bodyLarge: TextStyle(color: Colors.white),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.white),
    labelLarge: TextStyle(color: Colors.white),
    labelMedium: TextStyle(color: Colors.white),
    labelSmall: TextStyle(color: Colors.white),
  ),
);

ThemeData lightMode() => ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  colorSchemeSeed: HexColor('#42a5f5').withValues(alpha: .6),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    shadowColor: Colors.black.withValues(alpha: .25),
    elevation: 3,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
  ),
  iconTheme: const IconThemeData(color: Colors.black),
  textTheme: const TextTheme(
    displayLarge: TextStyle(color: Colors.black),
    displayMedium: TextStyle(color: Colors.black),
    displaySmall: TextStyle(color: Colors.black),
    headlineLarge: TextStyle(color: Colors.black),
    headlineMedium: TextStyle(color: Colors.black),
    headlineSmall: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
    titleMedium: TextStyle(color: Colors.black),
    titleSmall: TextStyle(color: Colors.black),
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(color: Colors.black),
    labelLarge: TextStyle(color: Colors.black),
    labelMedium: TextStyle(color: Colors.black),
    labelSmall: TextStyle(color: Colors.black),
  ),
);
