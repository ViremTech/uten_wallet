import 'package:flutter/material.dart';

import '../constant/constant.dart';

final darkTheme = ThemeData(
  fontFamily: 'Orbitron',
  brightness: Brightness.dark,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: backgroundColor,
  appBarTheme: AppBarTheme(
    backgroundColor: backgroundColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: 'Orbitron',
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      backgroundColor: Colors.transparent,
      textStyle: TextStyle(
        fontFamily: 'Orbitron',
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
    ),
  ),
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      fontFamily: 'Orbitron',
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Orbitron',
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: Colors.white24),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: Colors.white24),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: primaryColor, width: 2),
    ),
    labelStyle: TextStyle(
      fontFamily: 'Orbitron',
      fontSize: 14,
      color: Colors.white,
    ),
    hintStyle: TextStyle(
      fontFamily: 'Orbitron',
      fontSize: 14,
      color: Colors.white38,
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  colorScheme: ColorScheme.dark(
    primary: primaryColor,
    secondary: Colors.deepPurpleAccent,
  ),
);
