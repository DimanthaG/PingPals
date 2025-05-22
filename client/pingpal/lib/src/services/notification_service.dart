import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Enum for notification types
enum NotificationType {
  FRIEND_REQUEST,
  FRIEND_ACCEPT,
  FRIEND_DECLINE,
  FRIEND_REMOVE,
  EVENT_INVITE,
  EVENT_UPDATE,
  EVENT_REMINDER,
  EVENT_JOINED,
  EVENT_LEFT,
  EVENT_CANCELLED,
  CHAT_MESSAGE,
  CHAT_MENTION,
  SYSTEM
}

// Get string representation of notification type
extension NotificationTypeExtension on NotificationType {
  String get value {
    return toString().split('.').last;
  }
  
  // Get string representation from string
  static NotificationType? fromString(String? type) {
    if (type == null) return null;
    
    try {
      return NotificationType.values.firstWhere(
        (e) => e.value == type,
        orElse: () => NotificationType.SYSTEM,
      );
    } catch (e) {
      return NotificationType.SYSTEM;
    }
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String body;
  final Map<String, dynamic> data;
  final DateTime timestamp;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.data,
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
    'isRead': isRead,
  };

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      data: json['data'] ?? {},
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['isRead'] ?? false,
    );
  }
  
  NotificationType? get type {
    return NotificationTypeExtension.fromString(data['type']);
  }
}

class NotificationService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  // List to store local notifications
  final RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  
  static String get baseUrl {
    // Use HTTPS for production endpoints on all devices
    return 'https://pingpals-backend.onrender.com/api';
  }

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> initialize() async {
    print('Initializing NotificationService...');
    
    try {
      // Check if running on simulator
      bool isSimulator = false;
      if (Platform.isIOS) {
        if (const bool.fromEnvironment('dart.vm.product') == false) {
          print('Running on iOS Simulator - FCM token will not be available');
          isSimulator = true;
        }
      }

      // Load saved notifications
      await _loadSavedNotifications();
      
      // Load and merge any background notifications
      await _loadBackgroundNotifications();

      // Request notification permissions with retry
      NotificationSettings? settings;
      int retryCount = 0;
      while (settings == null && retryCount < 3) {
        try {
          settings = await _firebaseMessaging.requestPermission(
            alert: true,
            badge: true,
            sound: true,
            provisional: false,
          );
          print('User notification settings: ${settings.authorizationStatus}');
        } catch (e) {
          print('Attempt ${retryCount + 1} failed to request permissions: $e');
          retryCount++;
          if (retryCount < 3) await Future.delayed(Duration(seconds: 1));
        }
      }

      // Set up foreground notification presentation options
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Set up message handlers
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen((message) {
        print('Message opened app: ${message.data}');
        handleNotificationTap(message.data);
      });

      // Skip FCM token retrieval on simulator
      if (isSimulator) {
        print('Skipping FCM token retrieval on simulator');
        return;
      }

      // Get FCM token with retry
      String? fcmToken;
      retryCount = 0;
      while (fcmToken == null && retryCount < 3) {
        try {
          fcmToken = await _firebaseMessaging.getToken();
          if (fcmToken != null) {
            print('Successfully retrieved FCM token');
            await updateFcmToken(fcmToken);
          }
        } catch (e) {
          print('Attempt ${retryCount + 1} failed to get FCM token: $e');
          retryCount++;
          if (retryCount < 3) {
            await Future.delayed(Duration(seconds: 1));
          }
        }
      }

      // Listen for token refresh
      _firebaseMessaging.onTokenRefresh.listen((String token) {
        print('FCM Token refreshed: $token');
        updateFcmToken(token);
      });
      
      print('NotificationService initialization completed');
    } catch (e) {
      print('Error in NotificationService initialization: $e');
    }
  }

  Future<void> _loadSavedNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedNotifications = prefs.getStringList('notifications') ?? [];
      
      notifications.clear();
      for (var notificationJson in savedNotifications) {
        try {
          final notificationData = json.decode(notificationJson);
          final notification = NotificationModel.fromJson(notificationData);
          notifications.add(notification);
        } catch (e) {
          print('Error parsing saved notification: $e');
        }
      }
      
      // Sort by timestamp (newest first)
      notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      print('Loaded ${notifications.length} saved notifications');
    } catch (e) {
      print('Error loading saved notifications: $e');
    }
  }
  
  Future<void> _loadBackgroundNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final backgroundNotifications = prefs.getStringList('background_notifications') ?? [];
      
      if (backgroundNotifications.isNotEmpty) {
        print('Found ${backgroundNotifications.length} background notifications');
        
        for (var notificationJson in backgroundNotifications) {
          try {
            final notificationData = json.decode(notificationJson);
            final notification = NotificationModel.fromJson(notificationData);
            
            // Add to the main notifications list
            notifications.insert(0, notification);
          } catch (e) {
            print('Error parsing background notification: $e');
          }
        }
        
        // Clear the background notifications after loading
        await prefs.setStringList('background_notifications', []);
        
        // Sort and save the combined notifications
        notifications.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        
        // Limit to 50 notifications
        if (notifications.length > 50) {
          notifications.removeRange(50, notifications.length);
        }
        
        // Save the merged notifications
        await saveNotifications();
        
        print('Merged background notifications into main notifications list');
      }
    } catch (e) {
      print('Error loading background notifications: $e');
    }
  }
  
  Future<void> saveNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notificationsJson = notifications
          .map((notification) => json.encode(notification.toJson()))
          .toList();
      
      await prefs.setStringList('notifications', notificationsJson);
      print('Saved ${notifications.length} notifications');
    } catch (e) {
      print('Error saving notifications: $e');
    }
  }
  
  void addNotification(String title, String body, Map<String, dynamic> data) {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      data: data,
      timestamp: DateTime.now(),
    );
    
    // Add to list
    notifications.insert(0, notification);
    
    // Limit to 50 notifications
    if (notifications.length > 50) {
      notifications.removeLast();
    }
    
    // Save updated list
    saveNotifications();
  }
  
  void markNotificationAsRead(String id) {
    final index = notifications.indexWhere((notification) => notification.id == id);
    if (index != -1) {
      notifications[index].isRead = true;
      saveNotifications();
    }
  }
  
  void markAllNotificationsAsRead() {
    for (var notification in notifications) {
      notification.isRead = true;
    }
    saveNotifications();
  }
  
  void clearNotifications() {
    notifications.clear();
    saveNotifications();
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      print('Received foreground message: ${notification.title}');
      
      // Save notification to local storage
      addNotification(
        notification.title ?? 'New Notification',
        notification.body ?? '',
        message.data,
      );
      
      // Using Firebase's built-in notification display
    }
  }

  void handleNotificationTap(Map<String, dynamic> data) {
    final type = NotificationTypeExtension.fromString(data['type']);
    
    switch (type) {
      case NotificationType.FRIEND_REQUEST:
        Get.toNamed('/friend-requests');
        break;
      
      case NotificationType.FRIEND_ACCEPT:
      case NotificationType.FRIEND_DECLINE:
      case NotificationType.FRIEND_REMOVE:
        Get.toNamed('/friends');
        break;
      
      case NotificationType.EVENT_INVITE:
      case NotificationType.EVENT_UPDATE:
      case NotificationType.EVENT_REMINDER:
      case NotificationType.EVENT_JOINED:
      case NotificationType.EVENT_LEFT:
      case NotificationType.EVENT_CANCELLED:
        if (data['entityId'] != null) {
          Get.toNamed('/event/${data['entityId']}');
        } else {
          Get.toNamed('/events');
        }
        break;
      
      case NotificationType.CHAT_MESSAGE:
      case NotificationType.CHAT_MENTION:
        if (data['entityId'] != null) {
          Get.toNamed('/event/${data['entityId']}/chat');
        }
        break;
      
      case NotificationType.SYSTEM:
      default:
        // For unknown types, go to notification center
        Get.toNamed('/notifications');
        break;
    }
  }

  Future<void> updateFcmToken(String token) async {
    final accessToken = await _storage.read(key: 'jwtToken');
    print('Retrieved JWT token for FCM update: ${accessToken != null ? "Token exists" : "Token is null"}');
    
    if (accessToken == null) {
      print('Cannot update FCM token: No JWT token found');
      return;
    }

    try {
      print('Attempting to update FCM token on server...');
      print('FCM Token being sent: ${token.substring(0, 10)}...'); 
      
      final response = await http.post(
        Uri.parse('$baseUrl/notifications/token'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({'token': token}),
      );
      
      print('Server response status code: ${response.statusCode}');
      print('Server response body: ${response.body}');
      
      if (response.statusCode == 200) {
        print('✅ Successfully stored FCM token on server');
      } else {
        print('❌ Failed to update FCM token: ${response.body}');
      }
    } catch (e) {
      print('❌ Error updating FCM token: $e');
    }
  }
}
