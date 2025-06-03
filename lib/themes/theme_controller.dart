import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController with ChangeNotifier {
  bool _isDarkMode = false;
  late SharedPreferences _prefs;

  bool get isDarkMode => _isDarkMode;

  Future<void> loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  Future<void> toggleTheme(bool isOn) async {
    _isDarkMode = isOn;
    await _prefs.setBool('isDarkMode', isOn);
    notifyListeners();
  }
}
