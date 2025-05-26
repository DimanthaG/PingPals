import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pingpal/src/widgets/nav_bar.dart';
import 'package:pingpal/theme/theme_notifier.dart';
import 'package:pingpal/src/screens/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pingpal/src/services/notification_service.dart';
import 'package:pingpal/src/utils/auth_diagnostics.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");

  // Handle the received message
  RemoteNotification? notification = message.notification;
  if (notification != null) {
    print('Background notification received: ${notification.title}');

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
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('===== PingPals App Starting =====');
  print('Debug mode: ${kDebugMode}');

  // Initialize Firebase with retry
  bool firebaseInitialized = false;
  int retryCount = 0;
  while (!firebaseInitialized && retryCount < 3) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      firebaseInitialized = true;
      print('Firebase initialized successfully');
    } catch (e) {
      print('Firebase initialization attempt ${retryCount + 1} failed: $e');
      retryCount++;
      if (retryCount < 3) await Future.delayed(Duration(seconds: 1));
    }
  }

  if (!firebaseInitialized) {
    print('Failed to initialize Firebase after 3 attempts');
  }

  // Run auth diagnostics
  try {
    await AuthDiagnostics.runDiagnostics();
  } catch (e) {
    print('Error running diagnostics: $e');
  }

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(MyApp(notificationService: notificationService));
}

class MyApp extends StatelessWidget {
  final ThemeNotifier themeNotifier = ThemeNotifier();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final NotificationService notificationService;

  MyApp({required this.notificationService});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Use GetMaterialApp for navigation
      title: 'PingPals',
      theme: themeNotifier.currentTheme,
      debugShowCheckedModeBanner: false, // Remove debug banner for cleaner UI
      defaultTransition:
          Transition.fadeIn, // Smooth transitions between screens
      home: FutureBuilder<String?>(
        future: _checkStoredToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF8C00)),
                ),
              ),
            );
          }

          return snapshot.data != null
              ? NavBar(themeNotifier: themeNotifier)
              : LoginPage(
                  themeNotifier: themeNotifier,
                  onLoginSuccess: _navigateToMainApp,
                );
        },
      ),
      getPages: [
        GetPage(
            name: '/login',
            page: () => LoginPage(
                  themeNotifier: themeNotifier,
                  onLoginSuccess: _navigateToMainApp,
                )),
        GetPage(name: '/nav', page: () => NavBar(themeNotifier: themeNotifier)),
        GetPage(
            name: '/notifications',
            page: () =>
                NavBar(themeNotifier: themeNotifier, initialTabIndex: 3)),
        GetPage(
            name: '/friend-requests',
            page: () =>
                NavBar(themeNotifier: themeNotifier, initialTabIndex: 1)),
        GetPage(
            name: '/friends',
            page: () =>
                NavBar(themeNotifier: themeNotifier, initialTabIndex: 1)),
      ],
    );
  }

  Future<String?> _checkStoredToken() async {
    return await secureStorage.read(key: 'jwtToken');
  }

  void _navigateToMainApp(BuildContext context) {
    // Just navigate to the main app, FCM token is already handled in login
    Navigator.of(context).pushNamedAndRemoveUntil('/nav', (route) => false);
  }
}
