import 'package:flutter/material.dart';
import 'package:pingpal/src/widgets/nav_bar.dart';
import 'package:pingpal/theme/theme_notifier.dart';
import 'package:pingpal/src/screens/login.dart'; // Import Login Page
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeNotifier themeNotifier = ThemeNotifier();
  final FlutterSecureStorage secureStorage =
      FlutterSecureStorage(); // Secure storage instance

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _checkStoredToken(), // Check if there's a stored JWT token
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        }

        return AnimatedBuilder(
          animation: themeNotifier,
          builder: (context, child) {
            return MaterialApp(
              title: 'PingPals',
              theme: themeNotifier.currentTheme,
              routes: {
                '/login': (context) => LoginPage(
                      themeNotifier: themeNotifier,
                      onLoginSuccess: _navigateToMainApp,
                    ),
                '/nav': (context) => NavBar(themeNotifier: themeNotifier),
              },
              home: snapshot.data != null
                  ? NavBar(themeNotifier: themeNotifier)
                  : LoginPage(
                      themeNotifier: themeNotifier,
                      onLoginSuccess: _navigateToMainApp,
                    ),
            );
          },
        );
      },
    );
  }

  Future<String?> _checkStoredToken() async {
    return await secureStorage.read(key: 'jwtToken');
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
