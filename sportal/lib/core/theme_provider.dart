// lib/core/theme_provider.dart
import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeProvider with ChangeNotifier {
  AppTheme _currentTheme = DarkTheme();

  AppTheme get currentTheme => _currentTheme;

  void toggleTheme() {
    _currentTheme = _currentTheme is DarkTheme ? LightTheme() : DarkTheme();
    notifyListeners();
  }
}
