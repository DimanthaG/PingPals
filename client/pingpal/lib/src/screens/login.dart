import 'package:flutter/material.dart';
import 'package:pingpal/src/screens/signup.dart';
import 'package:pingpal/theme/theme_notifier.dart';

class LoginPage extends StatelessWidget {
  final ThemeNotifier themeNotifier;
  final void Function(BuildContext) onLoginSuccess; // Pass navigation callback

  LoginPage({required this.themeNotifier, required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeNotifier.isDarkMode;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PingPals!',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color:
                    isDarkMode ? Colors.orangeAccent : const Color(0xFFFF8C00),
              ),
            ),
            const SizedBox(height: 32.0),
            _buildTextField(
              context: context,
              labelText: 'Email',
              icon: Icons.email,
              isDarkMode: isDarkMode,
            ),
            const SizedBox(height: 16.0),
            _buildTextField(
              context: context,
              labelText: 'Password',
              icon: Icons.lock,
              isDarkMode: isDarkMode,
              obscureText: true,
            ),
            const SizedBox(height: 32.0),
            _buildLoginButton(context, theme, isDarkMode),
            const SizedBox(height: 16.0),
            GestureDetector(
              onTap: () {
                // Navigate to the SignUp page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SignUpPage(themeNotifier: themeNotifier),
                  ),
                );
              },
              child: Text(
                "Don't have an account? Sign up",
                style: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required String labelText,
    required IconData icon,
    bool isDarkMode = false,
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: isDarkMode ? Color(0xFF424242) : Colors.grey[200],
        labelText: labelText,
        prefixIcon:
            Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        labelStyle:
            TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
      ),
    );
  }

  Widget _buildLoginButton(
      BuildContext context, ThemeData theme, bool isDarkMode) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Perform login logic and on success, navigate to the main app
          onLoginSuccess(context); // Use the callback to navigate
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF8C00),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'Login',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
