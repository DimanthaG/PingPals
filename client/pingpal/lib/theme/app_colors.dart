import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const primaryOrange = Color(0xFFFF8C00);
  static const secondaryOrange = Color.fromARGB(255, 185, 58, 3);

  // Dark Theme Colors
  static const darkBackground = Color(0xFF1A1A1A);
  static const darkCardBackground = Color(0xFF2A2A2A);
  static const darkDivider = Color(0xFF404040);

  // Light Theme Colors
  static const lightBackground = Colors.white;
  static const lightCardBackground = Color(0xFFF5F5F5);
  static const lightDivider = Color(0xFFE0E0E0);

  // Transparent Colors
  static final darkTransparent = Colors.grey[900]?.withOpacity(0.3);
  static final lightTransparent = Colors.grey[100]?.withOpacity(0.7);

  // Text Colors
  static const darkTextPrimary = Colors.white;
  static const darkTextSecondary = Colors.white70;
  static const darkTextTertiary = Colors.white54;

  static const lightTextPrimary = Colors.black;
  static const lightTextSecondary = Colors.black87;
  static const lightTextTertiary = Colors.black54;

  // Gradient Colors
  static const gradientColors = [
    Color(0xFF1A1A1A),
    Color.fromARGB(255, 185, 58, 3),
    Color(0xFF1A1A1A),
  ];

  static const gradientStops = [0.0, 0.5, 1.0];
}
