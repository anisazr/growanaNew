// lib/theme/theme_provider.dart - OPTION C (MINIMAL)
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Minimal theme getters - HARUS ADA DUA GETTER INI
  ThemeData get lightTheme => ThemeData.light().copyWith(
        primaryColor: const Color(0xFF1D7140),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF1D7140),
          elevation: 0,
        ),
      );

  ThemeData get darkTheme => ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF1D7140),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF1D7140),
          elevation: 0,
        ),
      );

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveTheme();
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      notifyListeners();
    } catch (e) {
      print('Error loading theme: $e');
    }
  }

  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
    } catch (e) {
      print('Error saving theme: $e');
    }
  }
}