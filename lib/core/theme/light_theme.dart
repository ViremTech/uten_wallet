import 'package:flutter/material.dart';

import '../constant/constant.dart';

final lightTheme = ThemeData(
  fontFamily: 'Orbitron',
  brightness: Brightness.light,
  primaryColor: primaryColor,
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontFamily: 'Orbitron',
      fontSize: 20,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
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
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Orbitron',
      color: Colors.black54,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: Colors.black26),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: Colors.black26),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: primaryColor, width: 2),
    ),
    labelStyle: TextStyle(
      fontFamily: 'Orbitron',
      fontSize: 14,
      color: Colors.black87,
    ),
    hintStyle: TextStyle(
      fontFamily: 'Orbitron',
      fontSize: 14,
      color: Colors.black38, // faint hint
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  colorScheme: ColorScheme.light(
    primary: primaryColor,
    secondary: Colors.deepPurpleAccent,
  ),
);
