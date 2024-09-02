import 'package:flutter/material.dart';
import 'package:pingpal/theme/theme_notifier.dart';

class ProfilePage extends StatelessWidget {
  final ThemeNotifier themeNotifier;

  ProfilePage({required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Colors.white, // Background color for dark/light mode
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 40.0), // Padding for the profile section
            decoration: BoxDecoration(
              color: Color(0xFFFFA726), // Orange color for both themes
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
              ), // Curved bottom border
            ),
            child: Column(
              children: [
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 24, // Font size for the profile heading
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Color(0xFFFFA726)),
                ),
                SizedBox(height: 8.0),
                Text(
                  'GeenethK',
                  style: TextStyle(
                    fontSize: 22, // Font size for username
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Padding for the white section
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatCard('Events Attended', '27', Color(0xFFFF8A80)),
                    SizedBox(width: 16.0),
                    _buildStatCard('Events Created', '14', Color(0xFF69F0AE)),
                  ],
                ),
                SizedBox(height: 16.0),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12.0), // Padding for the Upgrade to Premium section
                  decoration: BoxDecoration(
                    color: Color(0xFFFFEB3B),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upgrade to Premium\n1 Month Free Trial',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '1.99 CAD/month',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.0),
                _buildSwitchTile('Change Theme', themeNotifier, isDarkMode),
                _buildOptionTile('Blocked List', isDarkMode),
                _buildLogoutTile(isDarkMode), // Logout button as part of the list
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      width: 130, // Width for the stat cards
      padding: EdgeInsets.all(12.0), // Padding for the stat cards
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          SizedBox(height: 4.0), // Spacing between title and count
          Text(
            count,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0, // Font size for the count
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(String title, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0), // Padding for list items
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0), // Inner padding for list items
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF424242) : Colors.white, // Dark mode color for list items
          borderRadius: BorderRadius.circular(8.0), // Rounded corners for list items
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200, // Light shadow for list items
              blurRadius: 2.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0, // Font size for list item text
            color: isDarkMode ? Colors.white : Colors.black, // Dark mode text color
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(String title, ThemeNotifier themeNotifier, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0), // Padding for switch tile
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0), // Inner padding for switch tile
        decoration: BoxDecoration(
          color: isDarkMode ? Color(0xFF424242) : Colors.white, // Dark mode color for switch tile
          borderRadius: BorderRadius.circular(8.0), // Rounded corners for switch tile
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200, // Light shadow for switch tile
              blurRadius: 2.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0, // Font size for switch tile text
                color: isDarkMode ? Colors.white : Colors.black, // Dark mode text color
              ),
            ),
            Switch(
              value: themeNotifier.isDarkMode,
              onChanged: (value) {
                themeNotifier.toggleTheme();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutTile(bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.0), // Padding for logout tile
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0), // Inner padding for logout tile
        decoration: BoxDecoration(
          color: Color(0xFFE57373), // Red color for the logout button
          borderRadius: BorderRadius.circular(8.0), // Rounded corners for logout tile
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200, // Light shadow for logout tile
              blurRadius: 2.0,
              spreadRadius: 1.0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.0, // Font size for logout tile text
            ),
          ),
        ),
      ),
    );
  }
}
