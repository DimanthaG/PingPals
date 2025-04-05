import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pingpal/src/widgets/nav_bar.dart';
import 'package:pingpal/theme/theme_notifier.dart';
import 'package:pingpal/src/screens/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:pingpal/src/services/notification_service.dart';
import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
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
    return MaterialApp(
      title: 'PingPals',
      theme: themeNotifier.currentTheme,
      home: FutureBuilder<String?>(
        future: _checkStoredToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }

          return snapshot.data != null
              ? NavBar(themeNotifier: themeNotifier)
              : LoginPage(
                  themeNotifier: themeNotifier,
                  onLoginSuccess: _navigateToMainApp,
                );
        },
      ),
      routes: {
        '/login': (context) => LoginPage(
          themeNotifier: themeNotifier,
          onLoginSuccess: _navigateToMainApp,
        ),
        '/nav': (context) => NavBar(themeNotifier: themeNotifier),
      },
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
