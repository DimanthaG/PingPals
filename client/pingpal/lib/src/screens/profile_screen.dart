import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:pingpal/theme/theme_notifier.dart';
import 'package:pingpal/src/widgets/nav_bar.dart';
import 'package:pingpal/src/widgets/animated_background.dart';
import 'package:pingpal/src/widgets/custom_app_bar.dart';

class ProfilePage extends StatelessWidget with NavBarPadding {
  final ThemeNotifier themeNotifier;

  const ProfilePage({super.key, required this.themeNotifier});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: AnimatedBackground(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16.0,
                  left: 16.0,
                  right: 16.0,
                  bottom: NavBarPadding.getNavBarHeight(context) +
                      MediaQuery.of(context).padding.bottom +
                      16.0,
                ),
                children: [
                  // Header with title
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF8C00).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 28,
                            color: Color(0xFFFF8C00),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Profile',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: const Color(0xFFFF8C00),
                              ),
                        ),
                      ],
                    ),
                  ),

                  _buildProfileHeader(isDarkMode),
                  const SizedBox(height: 24.0),
                  _buildSectionHeader('Stats', context),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard(
                          'Events Attended', '27', const Color(0xFFFF8C00)),
                      _buildStatCard(
                          'Events Created', '14', const Color(0xFF6ECF68)),
                    ],
                  ),
                  const SizedBox(height: 24.0),
                  _buildSectionHeader('Membership', context),
                  const SizedBox(height: 16.0),
                  _buildPremiumTile(),
                  const SizedBox(height: 24.0),
                  _buildSectionHeader('Settings', context),
                  const SizedBox(height: 16.0),
                  _buildSwitchTile('Change Theme', themeNotifier, isDarkMode),
                  const SizedBox(height: 12.0),
                  _buildOptionTile('Blocked List', Icons.block, isDarkMode),
                  const SizedBox(height: 24.0),
                  _buildLogoutTile(isDarkMode, context),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            const Color(0xFFFF8C00).withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C00).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              title == 'Stats'
                  ? Icons.bar_chart
                  : title == 'Membership'
                      ? Icons.card_membership
                      : Icons.settings,
              size: 22,
              color: const Color(0xFFFF8C00),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFFFF8C00).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFFFF8C00),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      decoration: BoxDecoration(
        color:
            Colors.grey[900]?.withOpacity(0.6) ?? Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFFF8C00).withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.white.withOpacity(0.1),
                  child: const Icon(
                    Icons.person,
                    size: 70,
                    color: Color(0xFFFF8C00),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF8C00),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          const Text(
            'GeenethK',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8.0),
          const Text(
            'geeneth@example.com',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C00).withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFF8C00).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.workspace_premium,
                  color: Color(0xFFFF8C00),
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  'Premium Member',
                  style: TextStyle(
                    color: Color(0xFFFF8C00),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumTile() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color:
            Colors.grey[900]?.withOpacity(0.6) ?? Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: const Color(0xFFFF8C00).withOpacity(0.3),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Color(0xFFFF8C00),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium Membership',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Access to exclusive features',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white54,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Plan',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Monthly',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00),
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF8C00).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Text(
                  '1.99 CAD/month',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String count, Color color) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color:
            Colors.grey[900]?.withOpacity(0.6) ?? Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(
              title.contains('Attended')
                  ? Icons.event
                  : Icons.create_new_folder,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 16.0),
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 32.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile(String title, IconData icon, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color:
            Colors.grey[900]?.withOpacity(0.6) ?? Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        onTap: () {
          // Handle navigation to Blocked List or other options
        },
      ),
    );
  }

  Widget _buildSwitchTile(
      String title, ThemeNotifier themeNotifier, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color:
            Colors.grey[900]?.withOpacity(0.6) ?? Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.brightness_6,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: const Text(
          'Dark Mode',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
        trailing: Switch(
          value: themeNotifier.isDarkMode,
          onChanged: (value) {
            themeNotifier.toggleTheme();
          },
          activeColor: const Color(0xFFFF8C00),
          activeTrackColor: const Color(0xFFFF8C00).withOpacity(0.3),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      ),
    );
  }

  Widget _buildLogoutTile(bool isDarkMode, BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: Colors.red.withOpacity(0.3),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.red.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.logout,
            color: Colors.red,
            size: 24,
          ),
        ),
        title: const Text(
          'Logout',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w500,
            fontSize: 16.0,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
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
