import 'package:flutter/material.dart';

class AppTheme {
  static const Color lightThemeColor = Color.fromARGB(255, 255, 255, 255);
  static const Color lightThemeTextColor = Color.fromARGB(255, 34, 34, 34);
  static const Color lightThemeBackgroundColor = Color.fromARGB(255, 240, 240, 240);
  static const Color lightThemeSelectedTextColor = Color.fromARGB(255, 77, 77, 78);

  static const Color darkThemeColor = Color.fromARGB(255, 34, 34, 34);
  static const Color darkThemeTextColor = Color.fromARGB(255, 255, 255, 255);
  static const Color darkThemeBackgroundColor = Color.fromARGB(255, 15, 15, 15);
  static const Color darkThemeSelectedTextColor = Color.fromARGB(255, 178, 178, 177);

  static const Color themeColor = lightThemeColor;
  static const Color themeTextColor = lightThemeTextColor;
  static const Color themeBackgroundColor = lightThemeBackgroundColor;
  static const Color themeSelectedTextColor = lightThemeSelectedTextColor;

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: lightThemeColor,
      scaffoldBackgroundColor: lightThemeBackgroundColor,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: lightThemeTextColor),
        bodyMedium: TextStyle(color: lightThemeTextColor),
        titleLarge: TextStyle(color: lightThemeTextColor),
        titleMedium: TextStyle(color: lightThemeTextColor),
        titleSmall: TextStyle(color: lightThemeTextColor),
      ),
      colorScheme: const ColorScheme.light(
        primary: lightThemeColor,
        onPrimary: lightThemeTextColor,
        surface: lightThemeColor,
        onSurface: lightThemeTextColor,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkThemeColor,
      scaffoldBackgroundColor: darkThemeBackgroundColor,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: darkThemeTextColor),
        bodyMedium: TextStyle(color: darkThemeTextColor),
        titleLarge: TextStyle(color: darkThemeTextColor),
        titleMedium: TextStyle(color: darkThemeTextColor),
        titleSmall: TextStyle(color: darkThemeTextColor),
      ),
      colorScheme: const ColorScheme.dark(
        primary: darkThemeColor,
        onPrimary: darkThemeTextColor,
        surface: darkThemeColor,
        onSurface: darkThemeTextColor,
      ),
    );
  }

  static Color getThemeColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkThemeColor : lightThemeColor;
  }

  static Color getThemeTextColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkThemeTextColor : lightThemeTextColor;
  }

  static Color getThemeBackgroundColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkThemeBackgroundColor : lightThemeBackgroundColor;
  }

  static Color getThemeSelectedTextColor(Brightness brightness) {
    return brightness == Brightness.dark ? darkThemeSelectedTextColor : lightThemeSelectedTextColor;
  }
}
