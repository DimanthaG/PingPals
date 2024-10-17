import 'package:flutter/material.dart';
import 'package:pingpal/theme/theme_notifier.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final void Function(BuildContext) onLoginSuccess;

  LoginPage({required this.themeNotifier, required this.onLoginSuccess});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool isDarkMode;
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
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication auth = await account.authentication;
        String? idToken = auth.idToken;

        // Send the ID token to your server for verification
        await _authenticateWithServer(idToken!);

        widget.onLoginSuccess(context);
      }
    } catch (error) {
      print('Google Sign-In error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google Sign-In failed. Please try again.')),
      );
    }
  }

  Future<void> _authenticateWithServer(String idToken) async {
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
      } else {
        print('Server responded with status code ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed. Please try again.')),
        );
      }
    } catch (e) {
      print('Error authenticating with server: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }
}
