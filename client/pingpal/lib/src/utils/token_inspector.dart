import 'dart:convert';

/// A utility class to inspect JWT tokens for debugging purposes
class TokenInspector {
  /// Decodes a JWT token to inspect its contents
  /// This is used only for debugging and should not be used in production
  static Map<String, dynamic> decodeToken(String token) {
    try {
      // Split the token into parts
      final parts = token.split('.');
      if (parts.length != 3) {
        return {'error': 'Not a valid JWT token format'};
      }

      // Decode the payload (middle part)
      String payload = parts[1];
      // Add padding if needed
      while (payload.length % 4 != 0) {
        payload += '=';
      }
      // Replace URL encoding with base64 encoding
      payload = payload.replaceAll('-', '+').replaceAll('_', '/');
      
      // Decode the base64
      final decodedPayload = utf8.decode(base64Url.decode(payload));
      final payloadMap = jsonDecode(decodedPayload) as Map<String, dynamic>;
      
      // Return key information
      return {
        'iss': payloadMap['iss'] ?? 'Not found',
        'sub': payloadMap['sub'] ?? 'Not found',
        'aud': payloadMap['aud'] ?? 'Not found',
        'exp': payloadMap['exp'] != null 
            ? DateTime.fromMillisecondsSinceEpoch(payloadMap['exp'] * 1000).toString() 
            : 'Not found',
        'iat': payloadMap['iat'] != null 
            ? DateTime.fromMillisecondsSinceEpoch(payloadMap['iat'] * 1000).toString() 
            : 'Not found',
        'azp': payloadMap['azp'] ?? 'Not found',
        'email': payloadMap['email'] ?? 'Not found',
      };
    } catch (e) {
      return {'error': 'Failed to decode token: $e'};
    }
  }

  /// Checks if a token appears to be valid
  static bool isTokenValid(String token) {
    try {
      final decoded = decodeToken(token);
      if (decoded.containsKey('error')) {
        return false;
      }
      
      // Check if we have the necessary fields
      if (decoded['iss'] == 'Not found' || 
          decoded['sub'] == 'Not found' ||
          decoded['aud'] == 'Not found' ||
          decoded['exp'] == 'Not found') {
        return false;
      }
      
      // Check if token has expired
      if (decoded['exp'] != 'Not found') {
        final expParts = decoded['exp'].toString().split(' ');
        if (expParts.length > 1) {
          final expDate = DateTime.parse(expParts[0]);
          if (expDate.isBefore(DateTime.now())) {
            return false;
          }
        }
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }
} 