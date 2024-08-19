import 'package:flutter/material.dart';
import 'package:pingpal/src/screens/create_event_screen.dart';
import 'package:pingpal/src/screens/friend_list_screen.dart';
import 'package:pingpal/src/screens/home_screen.dart';
import 'package:pingpal/src/screens/notifications_screen.dart';
import 'package:pingpal/src/screens/settings_screen.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  // Custom color scheme and icon size
  final Color _selectedItemColor = Colors.blueAccent;
  final Color _unselectedItemColor = Colors.grey;
  final double _iconSize = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(),
          FriendListScreen(),
          CreateEventScreen(),
          NotificationsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: _iconSize),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people, size: _iconSize),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: _iconSize),
            label: 'Create Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: _iconSize),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: _iconSize),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _selectedItemColor,
        unselectedItemColor: _unselectedItemColor,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        elevation: 10,
        backgroundColor: Colors.black,
      ),
    );
  }
}
