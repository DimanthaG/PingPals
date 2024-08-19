import 'package:flutter/material.dart';

class FriendListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friends List'),
      ),
      body: Center(
        child: Text('Your Friends List'),
      ),
    );
  }
}
