import 'package:flutter/material.dart';
import 'package:pingpal/src/screens/create_ping_screen.dart';
import 'package:pingpal/src/screens/friend_list_screen.dart';
import 'package:pingpal/src/screens/home_screen.dart';
import 'package:pingpal/src/screens/notifications_screen.dart';
import 'package:pingpal/src/screens/profile_screen.dart';
import 'package:pingpal/theme/theme_notifier.dart';
import 'package:pingpal/src/services/notification_service.dart';
import 'package:get/get.dart';

class NavBar extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final int initialTabIndex;

  const NavBar({super.key, required this.themeNotifier, this.initialTabIndex = 0});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int _selectedIndex;
  final NotificationService _notificationService = NotificationService();
  final double _iconSize = 30;
  
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex;
  }

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
      bottomNavigationBar: Obx(() {
        // Count friend request notifications for Pals tab
        final friendRequestCount = _notificationService.notifications
            .where((notification) => 
                notification.data['type']?.toString().contains('FRIEND_REQUEST') == true && 
                !notification.isRead)
            .length;
            
        // Count event notifications for Your Pings tab
        final eventNotificationCount = _notificationService.notifications
            .where((notification) => 
                (notification.data['type']?.toString().contains('EVENT_') == true || 
                 notification.data['type'] == 'EVENT_INVITE' || 
                 notification.data['type'] == 'EVENT_UPDATE' || 
                 notification.data['type'] == 'EVENT_REMINDER') && 
                !notification.isRead)
            .length;
            
        return BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: _iconSize),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildNotificationIcon(friendRequestCount, Icons.people),
              label: 'Pals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle, size: _iconSize),
              label: 'Ping',
            ),
            BottomNavigationBarItem(
              icon: _buildNotificationIcon(eventNotificationCount, Icons.notifications),
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
        );
      }),
    );
  }
  
  Widget _buildNotificationIcon(int count, IconData icon) {
    if (count == 0) {
      return Icon(icon, size: _iconSize);
    }
    
    return Stack(
      children: [
        Icon(icon, size: _iconSize),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              count > 9 ? '9+' : count.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
