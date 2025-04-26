import 'package:flutter/material.dart';

class AppTheme {
  // Light theme with vibrant colors
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF6200EE), // Vibrant purple
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: const Color(0xFF6200EE), // Vibrant purple
      secondary: const Color(0xFF03DAC6), // Teal accent
      tertiary: const Color(0xFFFF9800), // Orange accent
      background: Colors.white,
      surface: Colors.white,
      error: const Color(0xFFB00020), // Deep red for errors
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF6200EE), // Vibrant purple
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );

  // Dark theme with vibrant colors
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212),
    primarySwatch: Colors.indigo,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF4A148C), // Deeper purple for dark theme
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: const Color(0xFFBB86FC), // Light purple for dark theme
      secondary: const Color(0xFF03DAC6), // Teal accent
      tertiary: const Color(0xFFFFB74D), // Light orange accent
      background: const Color(0xFF121212),
      surface: const Color(0xFF1E1E1E),
      error: const Color(0xFFCF6679), // Lighter red for dark theme
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFBB86FC), // Light purple
      foregroundColor: Colors.black,
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
  );
}
