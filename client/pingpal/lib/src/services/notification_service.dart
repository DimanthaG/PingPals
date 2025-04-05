import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:get/get.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8080/api';
    } else if (Platform.isIOS) {
      return 'http://127.0.0.1:8080/api';
    } else {
      return 'http://localhost:8080/api';
    }
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

      // Initialize local notifications first
      const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      const initializationSettingsIOS = DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );
      
      const initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onSelectNotification,
      );

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
        _handleNotificationTap(message.data);
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

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification != null) {
      print('Showing local notification for foreground message');
      await showNotification(
        notification.title ?? 'New Notification',
        notification.body ?? '',
        message.data,
      );
    }
  }

  Future<void> _onSelectNotification(NotificationResponse response) async {
    final payload = response.payload;
    if (payload != null) {
      final data = json.decode(payload);
      _handleNotificationTap(data);
    }
  }

  void _handleNotificationTap(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'FRIEND_REQUEST':
        Get.toNamed('/friend-requests');
        break;
      case 'FRIEND_REQUEST_ACCEPTED':
      case 'FRIEND_REQUEST_DECLINED':
      case 'FRIEND_REMOVED':
        Get.toNamed('/friends');
        break;
      case 'EVENT_INVITE':
      case 'EVENT_UPDATE':
      case 'EVENT_JOINED':
      case 'EVENT_LEFT':
      case 'EVENT_CANCELLED':
      case 'EVENT_REMINDER':
        if (data['eventId'] != null) {
          Get.toNamed('/event/${data['eventId']}');
        } else {
          Get.toNamed('/events');
        }
        break;
      case 'CHAT_MESSAGE':
      case 'CHAT_MENTION':
        if (data['eventId'] != null) {
          Get.toNamed('/event/${data['eventId']}/chat');
        }
        break;
    }
  }

  Future<void> showNotification(String title, String body, Map<String, dynamic> payload) async {
    const androidDetails = AndroidNotificationDetails(
      'default_notification_channel',
      'Default Notifications',
      channelDescription: 'Default notification channel',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: json.encode(payload),
    );
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
