import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  String _backgroundImage = 'assets/backg.jpg';
  Color _textColor = Colors.black;
  Color _iconColor = Colors.black;
  Color _scaffoldBackgroundColor = Colors.white; // Nouvelle propriété
  Color _cardColor = Colors.white; // Nouvelle propriété

  ThemeMode get themeMode => _themeMode;
  String get backgroundImage => _backgroundImage;
  Color get textColor => _textColor;
  Color get iconColor => _iconColor;
  Color get scaffoldBackgroundColor => _scaffoldBackgroundColor; // Getter
  Color get cardColor => _cardColor; // Getter

  ThemeProvider() {
    _loadTheme();
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _backgroundImage = isDark ? 'assets/ciel1.jpg' : 'assets/backg.jpg';
    _textColor = isDark ? Colors.white : Colors.black;
    _iconColor = isDark ? Colors.white : Colors.black;
    _scaffoldBackgroundColor = isDark ? Colors.grey[900]! : Colors.white; // Couleur de fond
    _cardColor = isDark ? Colors.grey[800]! : Colors.white; // Couleur des cartes
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    _backgroundImage = isDark ? 'assets/ciel1.jpg' : 'assets/backg.jpg';
    _textColor = isDark ? Colors.white : Colors.black;
    _iconColor = isDark ? Colors.white : Colors.black;
    _scaffoldBackgroundColor = isDark ? Colors.grey[900]! : Colors.white; // Charger la couleur de fond
    _cardColor = isDark ? Colors.grey[800]! : Colors.white; // Charger la couleur des cartes
    notifyListeners();
  }
}