import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Log the message but use Firebase's built-in notification display
  RemoteNotification? notification = message.notification;
  if (notification != null) {
    print('Background message received: ${notification.title}');
    
    try {
      // Save notification to local storage for retrieval when app opens
      final notificationData = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': notification.title ?? 'New Notification',
        'body': notification.body ?? '',
        'data': message.data,
        'timestamp': DateTime.now().toIso8601String(),
        'isRead': false,
      };
      
      // Get shared preferences
      final prefs = await SharedPreferences.getInstance();
      
      // Get existing notifications or empty list
      final List<String> savedNotifications = 
          prefs.getStringList('background_notifications') ?? [];
      
      // Add new notification
      savedNotifications.add(json.encode(notificationData));
      
      // Limit to 50 notifications by removing oldest if needed
      if (savedNotifications.length > 50) {
        savedNotifications.removeAt(0);
      }
      
      // Save back to shared preferences
      await prefs.setStringList('background_notifications', savedNotifications);
      
      print('Saved background notification: ${notification.title}');
    } catch (e) {
      print('Error saving background notification: $e');
    }
    
    // Firebase will automatically display the notification
  }
}