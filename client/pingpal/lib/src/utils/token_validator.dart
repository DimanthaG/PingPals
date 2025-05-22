import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class TokenValidator {
  static final String serverUrl = 'https://pingpals-backend.onrender.com';

  static Future<void> validateToken({
    required String idToken,
    required Function(String) onSuccess,
    required Function(String) onError,
  }) async {
    try {
      print('Validating token directly with server: $serverUrl/auth/google');
      print('Token length: ${idToken.length}');
      print('Token prefix: ${idToken.substring(0, 10)}...');
      
      final response = await http.post(
        Uri.parse('$serverUrl/auth/google'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'idToken': idToken}),
      );

      print('Server validation response code: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String message = 'Token valid. User authenticated.';
        if (responseData.containsKey('email')) {
          message += ' Email: ${responseData['email']}';
        }
        onSuccess(message);
      } else {
        String errorDetails = '';
        try {
          errorDetails = response.body;
        } catch (e) {
          errorDetails = 'Could not parse error details: $e';
        }
        
        onError('Token validation failed (${response.statusCode}): $errorDetails');
      }
    } catch (e) {
      onError('Error during token validation: $e');
    }
  }

  static Future<void> checkServerHealth({
    required Function(String) onResult,
  }) async {
    try {
      final healthEndpoint = '$serverUrl/health';
      print('Checking server health: $healthEndpoint');
      
      final response = await http.get(Uri.parse(healthEndpoint));
      
      if (response.statusCode == 200) {
        onResult('Server is healthy: ${response.body}');
      } else {
        onResult('Server health check failed: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      onResult('Error checking server health: $e');
    }
  }

  // Display a dialog in the app to quickly test token validation
  static void showTokenValidationDialog(BuildContext context) {
    String token = '';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Token Validator'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'ID Token',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              onChanged: (value) => token = value,
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (token.isNotEmpty) {
                  validateToken(
                    idToken: token,
                    onSuccess: (msg) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(msg), backgroundColor: Colors.green),
                      );
                      Navigator.pop(context);
                    },
                    onError: (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error), backgroundColor: Colors.red),
                      );
                    },
                  );
                }
              },
              child: Text('Validate Token'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                checkServerHealth(
                  onResult: (result) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result)),
                    );
                  },
                );
              },
              child: Text('Check Server Health'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
} 