import 'package:flutter/material.dart';
import 'src/widgets/nav_bar.dart';
import 'theme/theme_notifier.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeNotifier themeNotifier = ThemeNotifier();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeNotifier,
      builder: (context, child) {
        return MaterialApp(
          title: 'PingPals',
          theme: themeNotifier.currentTheme,
          home: NavBar(themeNotifier: themeNotifier),
        );
      },
    );
  }
}
