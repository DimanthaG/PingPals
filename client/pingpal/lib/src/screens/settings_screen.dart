import 'package:flutter/material.dart';
import 'package:pingpal/theme/theme_notifier.dart';

class SettingsScreen extends StatelessWidget {
  final ThemeNotifier themeNotifier;

  SettingsScreen({required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Center(
        child: SwitchListTile(
          title: Text('Dark Mode'),
          value: themeNotifier.isDarkMode,
          onChanged: (value) {
            themeNotifier.toggleTheme();
          },
          secondary: Icon(
            themeNotifier.isDarkMode ? Icons.dark_mode : Icons.light_mode,
          ),
        ),
      ),
    );
  }
}
