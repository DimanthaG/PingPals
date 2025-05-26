import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  primarySwatch: Colors.blue,
  fontFamily: 'Poppins',
  brightness: Brightness.light,
  scaffoldBackgroundColor:
      Colors.grey[200] ?? Color(0xFFEEEEEE), // Default to a grey color if null
  appBarTheme: AppBarTheme(
    color: Colors.yellow[700] ?? Colors.yellow, // Default to yellow if null
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 24,
      letterSpacing: 0.5,
    ),
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
    headlineLarge: TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 30,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.3,
    ),
    headlineMedium: TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    ),
    headlineSmall: TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 20,
      letterSpacing: 0.1,
    ),
    titleLarge: TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontFamily: 'Poppins',
      color: Colors.grey[800] ?? Colors.grey,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      fontFamily: 'Poppins',
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  iconTheme: IconThemeData(
      color: Colors.grey[800] ?? Colors.grey), // Fallback to non-null grey
);
