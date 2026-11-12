import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App-wide language state. 'en' for English, 'ms' for Bahasa Malaysia.
class LocaleController {
  static final ValueNotifier<String> locale = ValueNotifier('en');

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    locale.value = prefs.getString('locale_code') ?? 'en';
  }

  static Future<void> setLocale(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale_code', code);
    locale.value = code;
  }
}