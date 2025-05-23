import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:pingpal/theme/theme_notifier.dart';
import 'package:pingpal/src/widgets/nav_bar.dart';

class ProfilePage extends StatelessWidget with NavBarPadding {
  final ThemeNotifier themeNotifier;

  const ProfilePage({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Colors.white,
      body: Column(
        children: [
          _buildProfileHeader(isDarkMode),
          Expanded(
            child: ListView(
              padding: EdgeInsets.only(
                top: 16.0,
                left: 16.0,
                right: 16.0,
                bottom: NavBarPadding.getNavBarHeight(context) + MediaQuery.of(context).padding.bottom + 16.0,
              ),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard('Events Attended', '27', Colors.orangeAccent),
                    _buildStatCard('Events Created', '14', Colors.greenAccent),
                  ],
                ),
                const SizedBox(height: 16.0),
                _buildPremiumTile(),
                const SizedBox(height: 16.0),
                _buildSwitchTile('Change Theme', themeNotifier, isDarkMode),
                _buildOptionTile('Blocked List', Icons.block, isDarkMode),
                _buildLogoutTile(isDarkMode, context),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.only(top: 8.0)),
          Center(
            child: Text(
              'Profile',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, size: 50, color: Color(0xFFFFA726)),
          ),
          const SizedBox(height: 8.0),
          Text(
            'GeenethK',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTile() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.yellow[700],
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Upgrade to Premium\n1 Month Free Trial',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            '1.99 CAD/month',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14.0,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(String title, IconData icon, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading:
            Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black54),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        tileColor: isDarkMode ? Color(0xFF424242) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        onTap: () {
          // Handle navigation to Blocked List or other options
        },
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, ThemeNotifier themeNotifier, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(
          Icons.brightness_6,
          color: isDarkMode ? Colors.white70 : Colors.black54,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        trailing: Switch(
          value: themeNotifier.isDarkMode,
          onChanged: (value) {
            themeNotifier.toggleTheme();
          },
        ),
        tileColor: isDarkMode ? Color(0xFF424242) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      ),
    );
  }

  Widget _buildLogoutTile(bool isDarkMode, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: const Text(
          'Logout',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          ),
        ),
        tileColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
        onTap: () async {
          await _handleLogout(context);
        },
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final FlutterSecureStorage _storage = FlutterSecureStorage();

    try {
      // Sign out from Google
      await _googleSignIn.signOut();

      // Clear stored tokens or user data
      await _storage.deleteAll();

      // Navigate to the login screen and remove all previous routes
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (error) {
      print('Logout failed: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }
}
