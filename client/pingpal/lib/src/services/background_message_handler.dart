import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Show notification even when app is terminated
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = 
      FlutterLocalNotificationsPlugin();

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

  RemoteNotification? notification = message.notification;
  if (notification != null) {
    await flutterLocalNotificationsPlugin.show(
      0,
      notification.title ?? 'New Notification',
      notification.body ?? '',
      notificationDetails,
    );
  }
}