import 'package:flutter/material.dart';
import 'package:pingpal/src/widgets/nav_bar.dart';
import 'package:pingpal/theme/theme_notifier.dart';
import 'package:pingpal/src/screens/login.dart'; // Import Login Page
import 'package:pingpal/src/screens/signup.dart'; // Import Sign Up Page

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeNotifier themeNotifier = ThemeNotifier();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeNotifier,
      builder: (context, child) {
        return MaterialApp(
          title: 'PingPals',
          theme: themeNotifier.currentTheme,
          // Set the home to LoginPage
          home: LoginPage(
            themeNotifier: themeNotifier,
            onLoginSuccess: _navigateToMainApp, // Define success login behavior
          ),
        );
      },
    );
  }

  void _navigateToMainApp(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NavBar(themeNotifier: themeNotifier),
      ),
    );
  }
}
