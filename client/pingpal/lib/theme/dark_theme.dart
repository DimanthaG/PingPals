import 'package:flutter/material.dart';

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  scaffoldBackgroundColor:
      Color.fromARGB(255, 36, 36, 36), // Matching background color
  appBarTheme: AppBarTheme(
    color: Color(0xFFFFD600), // Yellow accent color
    iconTheme: IconThemeData(color: Colors.black), // Dark icon color
    titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  ),
  cardColor: Color(0xFF1F1F1F), // Slightly lighter dark for cards
  colorScheme: ColorScheme.dark(
    primary: Color(0xFFFFD600), // Yellow primary color
    secondary: Color(0xFFFFD600), // Yellow accent color
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: Color(0xFFFFD600),
    inactiveTrackColor: Color(0xFFFFD600).withOpacity(0.3),
    thumbColor: Color(0xFFFFD600),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Color(0xFFFFD600), // Button background color
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Color(0xFF121212),
    selectedItemColor: Color(0xFFFFD600),
    unselectedItemColor: Colors.grey,
  ),
  textTheme: TextTheme(
    headlineSmall: TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28),
    bodyLarge: TextStyle(color: Colors.white, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.white),
    bodySmall: TextStyle(color: Colors.grey[400]),
    labelSmall: TextStyle(color: Colors.grey[400]), // Placeholder text style
  ),
  iconTheme: IconThemeData(color: Colors.grey[400]),
);
