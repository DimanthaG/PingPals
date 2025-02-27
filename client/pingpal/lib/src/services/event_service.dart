// event_service.dart
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class EventService {
  final String baseUrl = 'http://localhost:8080';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwtToken');
  }

  String extractUserIdFromJwt(String jwtToken) {
    final parts = jwtToken.split('.');
    if (parts.length != 3) throw Exception('Invalid JWT');
    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final Map<String, dynamic> payloadMap = json.decode(payload);
    return payloadMap['sub'];
  }

  Future<List<dynamic>> fetchFriends() async {
    final token = await getToken();
    if (token == null) throw Exception('JWT token not found');

    final response = await http.get(
      Uri.parse('$baseUrl/friends'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load friends list');
    }
  }

  Future<void> createEvent(Map<String, dynamic> event) async {
    final token = await getToken();
    if (token == null) throw Exception('JWT token not found');

    final response = await http.post(
      Uri.parse('$baseUrl/addEvent'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(event),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create event: ${response.body}');
    }
  }
}
