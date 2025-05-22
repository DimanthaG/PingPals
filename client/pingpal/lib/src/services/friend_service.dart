import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FriendService {
  final String baseUrl = 'https://pingpals-backend.onrender.com';
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  // Fetch the JWT token from secure storage
  Future<String?> getToken() async {
    return await secureStorage.read(key: 'jwtToken');
  }

  // Fetch friend requests for the authenticated user
  Future<List<dynamic>> fetchFriendRequests() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/friendRequests/pending'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body); // Includes senderName
      } else {
        throw Exception('Failed to load friend requests');
      }
    } catch (e) {
      throw Exception('Error loading friend requests: $e');
    }
  }

  // Search for users by username or email
  Future<List<dynamic>> searchUsers(String query) async {
    if (query.isEmpty) {
      throw Exception('Query cannot be empty');
    }

    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/searchUsers?query=$query'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch search results');
      }
    } catch (e) {
      throw Exception('Error searching for users: $e');
    }
  }

  // Send a friend request
  Future<void> sendFriendRequest(String friendEmail) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('JWT token not found');
      }

      print('Sending friend request to: $friendEmail');
      final response = await http.post(
        Uri.parse('$baseUrl/friendRequests/create/$friendEmail'),
        headers: {'Authorization': 'Bearer $token'},
      );
      print('Friend request response status: ${response.statusCode}');
      print('Friend request response body: ${response.body}');
      
      if (response.statusCode != 200) {
        throw Exception('Failed to send friend request: ${response.body}');
      }
    } catch (e) {
      print('Error sending friend request: $e');
      throw Exception('Error sending friend request: $e');
    }
  }

  // Accept a friend request
  Future<void> acceptFriendRequest(String requestId) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/friendRequests/accept/$requestId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to accept friend request');
      }
    } catch (e) {
      throw Exception('Error accepting friend request: $e');
    }
  }

  // Decline a friend request
  Future<void> declineFriendRequest(String requestId) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/friendRequests/decline/$requestId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to decline friend request');
      }
    } catch (e) {
      throw Exception('Error declining friend request: $e');
    }
  }

  // Fetch the authenticated user's friends
  Future<List<dynamic>> fetchFriends() async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/friends'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load friends list');
      }
    } catch (e) {
      throw Exception('Error loading friends: $e');
    }
  }

// Invite a friend to an event
  Future<void> inviteFriendToEvent(String eventId, String friendId) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/inviteFriend/$eventId/$friendId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to invite friend');
      }
    } catch (e) {
      throw Exception('Error inviting friend: $e');
    }
  }

// Remove a friend
  Future<void> removeFriend(String friendId) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception('JWT token not found');
      }

      final response = await http.delete(
        Uri.parse('$baseUrl/removeFriend/$friendId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to remove friend');
      }
    } catch (e) {
      throw Exception('Error removing friend: $e');
    }
  }
}
