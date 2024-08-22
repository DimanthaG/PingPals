import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  scaffoldBackgroundColor:
      Colors.grey[200] ?? Color(0xFFEEEEEE), // Default to a grey color if null
  appBarTheme: AppBarTheme(
    color: Colors.yellow[700] ?? Colors.yellow, // Default to yellow if null
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
  ),
  cardColor: Colors.white, // Standard card color for light theme
  colorScheme: ColorScheme.light(
    primary: Colors.blueAccent, // Blue primary color
    secondary: Colors.yellow[700] ??
        Colors.yellow, // Yellow accent color, with fallback
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: Colors.blueAccent,
    inactiveTrackColor: Colors.blueAccent.withOpacity(0.3),
    thumbColor: Colors.yellow[700] ?? Colors.yellow,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.yellow[700] ??
          Colors.yellow, // Button background color with fallback
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.blueAccent,
    unselectedItemColor: const Color.fromARGB(255, 113, 113, 113),
  ),
  textTheme: TextTheme(
    headlineSmall: TextStyle(
        color: Colors.black, fontWeight: FontWeight.bold, fontSize: 28),
    bodyLarge: TextStyle(color: Colors.black, fontSize: 18),
    bodyMedium: TextStyle(color: Colors.black),
    bodySmall: TextStyle(
        color: Colors.grey[800] ?? Colors.grey), // Fallback to a non-null grey
    labelSmall: TextStyle(color: Colors.black), // Placeholder text style
  ),
  iconTheme: IconThemeData(
      color: Colors.grey[800] ?? Colors.grey), // Fallback to non-null grey
);
