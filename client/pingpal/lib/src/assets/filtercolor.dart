import 'package:flutter/material.dart';

class FilterColor {
  static Color red(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? redDark : redLight;
  }

  static Color blue(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? blueDark : blueLight;
  }

  static Color green(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? greenDark : greenLight;
  }

  static Color yellow(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? yellowDark : yellowLight;
  }

  static Color orange(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? orangeDark : orangeLight;
  }

  static const Color redLight = Color(0xFFE53935);
  static const Color blueLight = Color(0xFF1E88E5);
  static const Color greenLight = Color(0xFF43A047);
  static const Color yellowLight = Color(0xFFFFC107);
  static const Color orangeLight = Color(0xFFFF5722);

  static const Color redDark = Color(0xFFB71C1C);
  static const Color blueDark = Color(0xFF0D47A1);
  static const Color greenDark = Color(0xFF1B5E20);
  static const Color yellowDark = Color(0xFFE65100);
  static const Color orangeDark = Color(0xFFBF360C);
  
  // Add more colors here as needed for both light and dark modes
}