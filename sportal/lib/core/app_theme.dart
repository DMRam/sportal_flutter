// lib/core/app_theme.dart
import 'package:flutter/material.dart';

abstract class AppTheme {
  Color get backgroundColor;
  Color get appBarColor;
  Color get drawerColor;
  Color get bottomNavBarColor;
  Color get cardColor;
  Color get primaryColor;
  Color get secondaryColor;
  Color get primaryTextColor;
  Color get secondaryTextColor;
  Color get buttonTextColor;
}

class DarkTheme implements AppTheme {
  @override
  Color get backgroundColor => const Color(0xFF121212);
  @override
  Color get appBarColor => const Color(0xFF1F1F1F);
  @override
  Color get drawerColor => const Color(0xFF1F1F1F);
  @override
  Color get bottomNavBarColor => const Color(0xFF1F1F1F);
  @override
  Color get cardColor => const Color(0xFF1F1F1F);
  @override
  Color get primaryColor => Colors.deepPurpleAccent;
  @override
  Color get secondaryColor => Colors.purpleAccent;
  @override
  Color get primaryTextColor => Colors.white;
  @override
  Color get secondaryTextColor => Colors.white70;
  @override
  Color get buttonTextColor => Colors.white;
}

class LightTheme implements AppTheme {
  @override
  Color get backgroundColor => const Color(0xFFF5F5F5);
  @override
  Color get appBarColor => Colors.white;
  @override
  Color get drawerColor => Colors.white;
  @override
  Color get bottomNavBarColor => Colors.white;
  @override
  Color get cardColor => Colors.white;
  @override
  Color get primaryColor => Colors.blueAccent;
  @override
  Color get secondaryColor => Colors.lightBlueAccent;
  @override
  Color get primaryTextColor => Colors.black87;
  @override
  Color get secondaryTextColor => Colors.black54;
  @override
  Color get buttonTextColor => Colors.white;
}
