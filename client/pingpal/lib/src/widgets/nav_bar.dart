import 'package:flutter/material.dart';
import 'dart:ui';  // For BackdropFilter
import 'dart:io';  // Add this for Platform check
import 'package:pingpal/src/screens/create_ping_screen.dart';
import 'package:pingpal/src/screens/friend_list_screen.dart';
import 'package:pingpal/src/screens/home_screen.dart';
import 'package:pingpal/src/screens/notifications_screen.dart';
import 'package:pingpal/src/screens/profile_screen.dart';
import 'package:pingpal/theme/theme_notifier.dart';
import 'package:pingpal/src/services/notification_service.dart';
import 'package:get/get.dart';

// Mixin to handle navbar padding in screens
mixin NavBarPadding {
  static double getNavBarHeight(BuildContext context) {
    return Platform.isIOS ? 65 : 60;
  }

  static EdgeInsets getScreenPadding(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return EdgeInsets.only(bottom: getNavBarHeight(context) + bottomPadding);
  }
}

class NavBar extends StatefulWidget {
  final ThemeNotifier themeNotifier;
  final int initialTabIndex;

  const NavBar({super.key, required this.themeNotifier, this.initialTabIndex = 0});

  // Get the total height including safe area
  static double getTotalNavBarHeight(BuildContext context) {
    return NavBarPadding.getNavBarHeight(context) + MediaQuery.of(context).padding.bottom;
  }

  // Helper method to get content padding
  static EdgeInsets getContentPadding(BuildContext context) {
    return NavBarPadding.getScreenPadding(context);
  }

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int _selectedIndex;
  final NotificationService _notificationService = NotificationService();
  final double _iconSize = 24;
  
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(),
          PalsScreen(),
          CreateEventScreen(),
          EventsPage(),
          ProfilePage(themeNotifier: widget.themeNotifier),
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
            
        return SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: (isDarkMode 
                      ? Color(0xFF242424).withOpacity(0.5) 
                      : Color(0xFFF3F0F7).withOpacity(0.5)
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode 
                          ? Colors.black.withOpacity(0.2) 
                          : Colors.grey.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: isDarkMode 
                        ? Colors.white.withOpacity(0.1) 
                        : Colors.black.withOpacity(0.05),
                      width: 0.5,
                    ),
                  ),
                  child: NavigationBarTheme(
                    data: NavigationBarThemeData(
                      indicatorShape: StadiumBorder(),
                      height: Platform.isIOS ? 65 : 60,
                      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                    ),
                    child: NavigationBar(
                      height: Platform.isIOS ? 65 : 60,
                      elevation: 0,
                      selectedIndex: _selectedIndex,
                      backgroundColor: Colors.transparent,
                      indicatorColor: (isDarkMode 
                        ? Color.fromARGB(255, 246, 167, 63).withOpacity(0.7) 
                        : Color.fromARGB(255, 246, 167, 63).withOpacity(0.7)
                      ),
                      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                      onDestinationSelected: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      destinations: [
                        NavigationDestination(
                          icon: Icon(Icons.home, size: _iconSize),
                          label: 'Home',
                        ),
                        NavigationDestination(
                          icon: _buildNotificationIcon(friendRequestCount, Icons.people),
                          label: 'Pals',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.add_circle_outline, size: _iconSize),
                          label: 'Ping',
                        ),
                        NavigationDestination(
                          icon: _buildNotificationIcon(eventNotificationCount, Icons.notifications),
                          label: 'Your Pings',
                        ),
                        NavigationDestination(
                          icon: Icon(Icons.person, size: _iconSize),
                          label: 'Profile',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
  
  Widget _buildNotificationIcon(int count, IconData icon) {
    if (count == 0) {
      return Icon(icon, size: _iconSize);
    }
    
    return Badge(
      backgroundColor: Colors.red,
      offset: Offset(10, -5),
      label: Text(
        count > 9 ? '9+' : count.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Icon(icon, size: _iconSize),
    );
  }
}
