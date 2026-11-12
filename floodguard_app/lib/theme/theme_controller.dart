import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide dark mode state. A simple ValueNotifier is enough here since
/// only one value (theme mode) needs to be shared between the Settings
/// screen and the root MaterialApp — no need for a heavier state
/// management package for something this small.
class ThemeController {
  static final ValueNotifier<ThemeMode> mode = ValueNotifier(ThemeMode.light);

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('dark_mode') ?? false;
    mode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> setDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', isDark);
    mode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }
}