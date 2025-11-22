import 'package:flutter/material.dart';

class PAppTheme{
  PAppTheme._();

  static ThemeData ligTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFFA47551),
    scaffoldBackgroundColor: Color(0xFFFDFBF9),
    cardColor: Color(0xFFE8DED4),
    textTheme: TextTheme(
      bodySmall: TextStyle(color: Color(0xFF333333)),
      bodyMedium: TextStyle(color: Color(0xFF333333)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFA47551),
        foregroundColor: Colors.white,
      )
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
      )
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFA47551),
      foregroundColor: Colors.black,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Color(0xFF121212),
    primaryColor: Color(0xFFA47551),
    cardColor: Color(0xFF1E1E1E),
    textTheme: TextTheme(
      bodySmall: TextStyle(color: Color(0xFFF5F5F5)),
      bodyMedium: TextStyle(color: Color(0xFFBDBDBD)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFA47551),
        foregroundColor: Colors.white,
      ),
    ),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
          )
      )
  );
}