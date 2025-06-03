import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController with ChangeNotifier {
  // private variable to track if dark mode is enabled
  bool _isDarkMode = false;
  // shared preferences instance for persistent storage
  late SharedPreferences _prefs;

  // getter to access current theme mode
  bool get isDarkMode => _isDarkMode;

  // load saved theme preference from shared preferences
  Future<void> loadTheme() async {
    _prefs = await SharedPreferences.getInstance(); // get shared preferences instance
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false; // load saved bool or default to false
    notifyListeners(); // notify listeners of theme change
  }

  // toggle theme and save preference persistently
  Future<void> toggleTheme(bool isOn) async {
    _isDarkMode = isOn; // update theme mode
    await _prefs.setBool('isDarkMode', isOn); // save updated preference to shared preferences
    notifyListeners(); // notify listeners so UI can update
  }
}