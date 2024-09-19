import 'package:flutter/material.dart';
import 'package:pingpal/src/screens/create_ping_screen.dart';
import 'package:pingpal/src/screens/friend_list_screen.dart';
import 'package:pingpal/src/screens/home_screen.dart';
import 'package:pingpal/src/screens/notifications_screen.dart';
import 'package:pingpal/src/screens/profile_screen.dart';
import 'package:pingpal/theme/theme_notifier.dart';

class NavBar extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  const NavBar({super.key, required this.themeNotifier});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final double _iconSize = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(),
          PalsScreen(),
          CreateEventScreen(),
          EventsPage(),
          ProfilePage(
              themeNotifier:
                  widget.themeNotifier), // Pass the themeNotifier here
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
            label: 'Pals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: _iconSize),
            label: 'Ping',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, size: _iconSize),
            label: 'Your Pings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: _iconSize),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow[700], // Yellow for selected item
        unselectedItemColor:
            widget.themeNotifier.isDarkMode ? Colors.grey : Colors.black54,
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
        backgroundColor:
            widget.themeNotifier.isDarkMode ? Color(0xFF242424) : Colors.white,
      ),
    );
  }
}
