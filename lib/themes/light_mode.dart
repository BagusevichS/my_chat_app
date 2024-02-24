import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.grey.shade500,
      onPrimary: Colors.grey.shade500,
      secondary: Colors.grey.shade100,/////
      onSecondary: Colors.grey.shade300,
      error: Colors.black,
      onError: Colors.white,
      background: Colors.white, ////
      onBackground: Color(0xFF81A7CC),//////
      surface: Color(0xFF81A7CC),
      onSurface: Colors.white,
      inversePrimary: Colors.grey.shade900,
    ),
    textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: Colors.grey.shade900,
        )
    )
);