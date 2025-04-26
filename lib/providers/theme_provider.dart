import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../theme/app_theme.dart';

// Provider that manages the current theme mode
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

// Notifier class to handle theme state changes
class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  // Load the saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    // final prefs = await SharedPreferences.getInstance();
    // final isDarkMode = prefs.getBool('isDarkMode') ?? false;
    // state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    state = ThemeMode.light; // Default to light theme for now
  }

  // Toggle between light and dark theme
  Future<void> toggleTheme() async {
    // final prefs = await SharedPreferences.getInstance();
    final isDarkMode = state == ThemeMode.dark;

    // Save the new theme mode to SharedPreferences
    // await prefs.setBool('isDarkMode', !isDarkMode);

    // Update the state
    state = isDarkMode ? ThemeMode.light : ThemeMode.dark;
  }
}
