import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.grey.shade700,
      onPrimary: Colors.grey.shade500,
      secondary: Colors.grey.shade800,
      onSecondary: Colors.grey.shade300,
      error: Colors.black,
      onError: Colors.white,
      background: Colors.grey.shade900,
      onBackground: Colors.transparent,
      surface: Colors.grey.shade100,
      onSurface: Colors.white,
      inversePrimary: Colors.grey.shade300,
    ),
    textTheme: TextTheme(
        bodyMedium: TextStyle(
          color: Colors.grey.shade100,
        )
    )
);