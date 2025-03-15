import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _backgroundImage = 'assets/back.jpg';
  Color _textColor = Colors.black;
  Color _iconColor = Colors.black;

  ThemeMode get themeMode => _themeMode;
  String get backgroundImage => _backgroundImage;
  Color get textColor => _textColor;
  Color get iconColor => _iconColor;

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _backgroundImage = isDark ? 'assets/ciel.jpg' : 'assets/back.jpg';
    _textColor = isDark ? Colors.white : Colors.black;
    _iconColor = isDark ? Colors.white : Colors.black;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _backgroundImage = isDark ? 'assets/ciel.jpg' : 'assets/back.jpg'; // Charger l'image
    _textColor = isDark ? Colors.white : Colors.black;
    _iconColor = isDark ? Colors.white : Colors.black;
    notifyListeners();
  }
}