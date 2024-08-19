import 'package:flutter/material.dart';
import 'src/widgets/nav_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Friend Notification App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Set NavBar as the home of the app
      home: const NavBar(),
    );
  }
}
