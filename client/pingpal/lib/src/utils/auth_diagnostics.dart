import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthDiagnostics {
  static Future<void> runDiagnostics() async {
    print('======= AUTHENTICATION DIAGNOSTICS =======');
    print('Platform: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}');
    print('Is physical device: ${!kIsWeb && !Platform.environment.containsKey('FLUTTER_TEST')}');
    
    // Check Firebase initialization status
    try {
      final FirebaseApp app = Firebase.app();
      print('Firebase initialized: ${app.name}');
      print('Firebase options: ${app.options.projectId}');
    } catch (e) {
      print('Firebase not initialized: $e');
    }
    
    // Check Google Sign-In capabilities
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId: Platform.isAndroid 
        ? '801373348761-9br5ei64qv6reu56ia5s96guu3im9mim.apps.googleusercontent.com'
        : null,
    );
    
    try {
      // Check if the user is already signed in
      final bool isSignedIn = await googleSignIn.isSignedIn();
      print('User is already signed in with Google: $isSignedIn');
      
      if (isSignedIn) {
        final currentUser = googleSignIn.currentUser;
        print('Current user: ${currentUser?.displayName} (${currentUser?.email})');
      }
    } catch (e) {
      print('Error checking Google Sign-In status: $e');
    }
    
    // Check server status
    try {
      final serverUrl = 'https://pingpals-backend.onrender.com/health';
      final response = await http.get(Uri.parse(serverUrl));
      print('Server status (${serverUrl}): ${response.statusCode}');
      
      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          print('Server response: $data');
        } catch (e) {
          print('Server response is not JSON: ${response.body}');
        }
      }
    } catch (e) {
      print('Error checking server status: $e');
    }
    
    print('========================================');
  }
} 