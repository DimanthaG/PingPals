import 'package:flutter/material.dart';
import 'package:pingpal/theme/theme_notifier.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginPage extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final void Function(BuildContext) onLoginSuccess;

  LoginPage({required this.themeNotifier, required this.onLoginSuccess});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool isDarkMode;
  bool _isSigningIn = false;  // Add this flag to prevent multiple sign-in attempts
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );
  final FlutterSecureStorage secureStorage =
      FlutterSecureStorage(); // Secure storage instance

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.themeNotifier.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'PingPals',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: isDarkMode ? Colors.orangeAccent : Color(0xFFFF8C00),
                ),
              ),
              SizedBox(height: 40),
              SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: Divider()),
                  SizedBox(width: 10),
                  Text(
                    'OR',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 20),
              _buildGoogleSignInButton(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleSignInButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _handleGoogleSignIn,
        icon: Image.asset(
          'assets/google_logo.png',
          height: 24.0,
          width: 24.0,
        ),
        label: Text(
          'Sign in with Google',
          style: TextStyle(fontSize: 18.0),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black54,
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isSigningIn) return;  // Prevent multiple simultaneous sign-in attempts
    
    try {
      setState(() {
        _isSigningIn = true;
      });

      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication auth = await account.authentication;
        String? idToken = auth.idToken;

        // Send the ID token to your server for verification
        bool success = await _authenticateWithServer(idToken!);
        
        if (success && mounted) {
          widget.onLoginSuccess(context);
        }
      }
    } catch (error) {
      print('Google Sign-In error: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google Sign-In failed. Please try again.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  Future<bool> _authenticateWithServer(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String accessToken = responseData['accessToken'];
        String refreshToken = responseData['refreshToken'];

        // Store both the access and refresh tokens securely
        await secureStorage.write(key: 'jwtToken', value: accessToken);
        await secureStorage.write(key: 'refreshToken', value: refreshToken);

        print('Tokens saved successfully');
        
        // Get and update FCM token right after storing the auth tokens
        try {
          final fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            final fcmResponse = await http.post(
              Uri.parse('http://localhost:8080/api/notifications/token'),
              headers: {
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({'token': fcmToken}),
            );
            
            print('FCM token update response: ${fcmResponse.statusCode}');
          }
        } catch (e) {
          print('Error updating FCM token: $e');
        }
        
        return true;
      } else {
        print('Server responded with status code ${response.statusCode}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication failed. Please try again.')),
          );
        }
        return false;
      }
    } catch (e) {
      print('Error authenticating with server: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
      return false;
    }
  }
}
