import 'package:flutter/material.dart';
import 'package:pingpal/theme/theme_notifier.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;
import 'package:pingpal/src/utils/token_inspector.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final void Function(BuildContext) onLoginSuccess;

  LoginPage({required this.themeNotifier, required this.onLoginSuccess});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool isDarkMode;
  bool _isSigningIn = false;
  late GoogleSignIn _googleSignIn;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Use a consistent backend URL
  String get backendUrl {
    return 'https://pingpals-backend.onrender.com';
  }

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.themeNotifier.isDarkMode;

    // Always use the web client ID for server authentication
    // This is crucial for token verification on the backend
    const String webClientId =
        '801373348761-9br5ei64qv6reu56ia5s96guu3im9mim.apps.googleusercontent.com';

    // Initialize GoogleSignIn with web client ID for all platforms
    _googleSignIn = GoogleSignIn(
      serverClientId: webClientId,
      scopes: ['email', 'profile'],
    );

    print('Platform: ${Platform.operatingSystem}');
    print(
        'GoogleSignIn initialized with serverClientId: ${_googleSignIn.serverClientId}');
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
              SizedBox(height: 10),
              if (Platform.isAndroid)
                TextButton(
                  onPressed: _showDebugDialog,
                  child: Text('Debug Info (Android Only)'),
                ),
              SizedBox(height: 20),
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

  void _showDebugDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Android Auth Debug Info'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Platform: ${Platform.operatingSystem}'),
                Text('Android Version: ${Platform.operatingSystemVersion}'),
                Text(
                    'Server Client ID: ${_googleSignIn.serverClientId ?? 'Not set'}'),
                Text('App ID: com.example.pingpal'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  _testDirectApiCall();
                  Navigator.of(context).pop();
                },
                child: Text('Test API Directly'),
              ),
              TextButton(
                onPressed: () {
                  _testGetToken();
                  Navigator.of(context).pop();
                },
                child: Text('Test Token'),
              ),
              TextButton(
                onPressed: () {
                  _tryFirebaseAuthFlow();
                  Navigator.of(context).pop();
                },
                child: Text('Use Firebase Auth'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        });
  }

  Future<void> _tryFirebaseAuthFlow() async {
    try {
      setState(() {
        _isSigningIn = true;
      });

      // Sign in with Google on Firebase Auth directly
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print('Google sign-in cancelled');
        setState(() {
          _isSigningIn = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Use the Google ID token directly instead of going through Firebase Auth
      // This avoids the PigeonUserDetails type casting error
      String? idToken = googleAuth.idToken;

      if (idToken != null) {
        print('Google ID token obtained, length: ${idToken.length}');
        print('Google ID token prefix: ${idToken.substring(0, 20)}...');

        // Examine token content
        Map<String, dynamic> tokenInfo = TokenInspector.decodeToken(idToken);
        print('Google token info: $tokenInfo');

        // Try authenticating with the Google token directly
        final bool success = await _authenticateWithServer(idToken);

        if (success && mounted) {
          widget.onLoginSuccess(context);
        }
      } else {
        print('Failed to get Google ID token');
        _showErrorDialog(
            'Authentication Error', 'Failed to obtain Google ID token');
      }
    } catch (e) {
      print('Firebase auth flow error: $e');
      _showErrorDialog('Authentication Error', 'Firebase auth flow error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  Future<void> _testGetToken() async {
    try {
      GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account != null) {
        GoogleSignInAuthentication auth = await account.authentication;
        if (auth.idToken != null) {
          Map<String, dynamic> tokenInfo =
              TokenInspector.decodeToken(auth.idToken!);
          _showTokenInfoDialog(tokenInfo);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to get ID token')),
          );
        }
      }
    } catch (e) {
      print('Token test error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Token test error: $e')),
      );
    }
  }

  void _showTokenInfoDialog(Map<String, dynamic> tokenInfo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Token Information'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: tokenInfo.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${entry.key}:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('${entry.value}'),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _testDirectApiCall() async {
    try {
      // Simple test call to the server to verify it's accessible
      final response = await http.get(Uri.parse('$backendUrl/health'));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'API Health check: ${response.statusCode} - ${response.body}')),
        );
      }
    } catch (e) {
      print('API Test Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('API Test Error: $e')),
        );
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isSigningIn) return; // Prevent multiple simultaneous sign-in attempts

    try {
      setState(() {
        _isSigningIn = true;
      });

      print('Starting Google Sign-In process...');

      // For Android, use Firebase Auth flow instead of direct Google Sign-In
      if (Platform.isAndroid) {
        await _tryFirebaseAuthFlow();
        return;
      }

      // For iOS and other platforms, use the regular flow
      // Check sign-in status before proceeding
      if (await _googleSignIn.isSignedIn()) {
        print('A user is already signed in. Signing out first...');
        await _googleSignIn.signOut();
      }

      GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        print('Successfully signed in with Google: ${account.email}');
        print('Display name: ${account.displayName}');
        print('Photo URL: ${account.photoUrl}');

        GoogleSignInAuthentication auth = await account.authentication;
        String? idToken = auth.idToken;
        String? accessToken = auth.accessToken;

        print('ID Token obtained: ${idToken != null ? 'Yes' : 'No'}');
        print('Access Token obtained: ${accessToken != null ? 'Yes' : 'No'}');
        print('ID Token length: ${idToken?.length ?? 0}');
        print('ID Token prefix: ${idToken?.substring(0, 20)}...');

        if (idToken == null) {
          print('Error: ID token is null after Google authentication');
          _showErrorDialog(
              'Authentication Error', 'Failed to obtain ID token from Google');
          throw Exception('Could not obtain ID token from Google');
        }

        print('Successfully obtained Google ID token');

        // Send the ID token to your server for verification
        bool success = await _authenticateWithServer(idToken);

        if (success && mounted) {
          widget.onLoginSuccess(context);
        }
      } else {
        print('Google sign-in was canceled by user');
      }
    } catch (error) {
      print('Google Sign-In error: $error');
      if (mounted) {
        _showErrorDialog(
            'Sign-In Failed', 'Error during Google Sign-In: $error');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSigningIn = false;
        });
      }
    }
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<bool> _authenticateWithServer(String idToken) async {
    try {
      print('Sending ID token to server for authentication...');
      print('Server URL: $backendUrl/auth/google');

      // Check token information before sending
      Map<String, dynamic> tokenInfo = TokenInspector.decodeToken(idToken);
      print('Token info: $tokenInfo');

      final response = await http.post(
        Uri.parse('$backendUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      print('Server authentication response code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String accessToken = responseData['accessToken'];
        String refreshToken = responseData['refreshToken'];

        // Store both the access and refresh tokens securely
        await secureStorage.write(key: 'jwtToken', value: accessToken);
        await secureStorage.write(key: 'refreshToken', value: refreshToken);

        print('Authentication tokens saved successfully');

        // Get and update FCM token right after storing the auth tokens
        try {
          final fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken != null) {
            print('Got FCM token: ${fcmToken.substring(0, 10)}...');

            final tokenResponse = await http.post(
              Uri.parse('$backendUrl/api/notifications/token'),
              headers: {
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              },
              body: jsonEncode({'token': fcmToken}),
            );

            print('FCM token update response: ${tokenResponse.statusCode}');
          } else {
            print('FCM token is null - could not update with server');
          }
        } catch (e) {
          print('Error updating FCM token: $e');
        }

        return true;
      } else {
        print(
            'Server authentication failed with status code ${response.statusCode}');
        try {
          print('Response body: ${response.body}');
          _showErrorDialog('Server Authentication Failed',
              'Status: ${response.statusCode}\nDetails: ${response.body}');
        } catch (e) {
          print('Could not parse response body');
          _showErrorDialog('Server Authentication Failed',
              'Status: ${response.statusCode}\nCould not parse response details.');
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Authentication failed. Please try again.')),
          );
        }
        return false;
      }
    } catch (e) {
      print('Error authenticating with server: $e');
      _showErrorDialog(
          'Connection Error', 'Failed to connect to authentication server: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      }
      return false;
    }
  }
}
