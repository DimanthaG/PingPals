import 'package:flutter/material.dart';
import 'package:pingpal/theme/theme_notifier.dart';

class SignUpPage extends StatefulWidget {
  final ThemeNotifier themeNotifier;

  SignUpPage({required this.themeNotifier});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late bool isDarkMode;
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool termsAccepted = false;

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.themeNotifier.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121212) : Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Form(
              key: _formKey, // Form key for validation
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60), // Top spacing
                  Text(
                    'Create your PingPals account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode
                          ? Colors.orangeAccent
                          : const Color(0xFFFF8C00),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  _buildTextField(
                    controller: firstNameController,
                    labelText: 'First Name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: lastNameController,
                    labelText: 'Last Name',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: usernameController,
                    labelText: 'Username',
                    icon: Icons.person_pin,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: emailController,
                    labelText: 'Email',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: passwordController,
                    labelText: 'Password',
                    icon: Icons.lock,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextField(
                    controller: confirmPasswordController,
                    labelText: 'Confirm Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Checkbox(
                        value: termsAccepted,
                        onChanged: (bool? value) {
                          setState(() {
                            termsAccepted = value ?? false;
                          });
                        },
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              termsAccepted = !termsAccepted;
                            });
                          },
                          child: Text(
                            'I accept the Terms and Conditions',
                            style: TextStyle(
                              color:
                                  isDarkMode ? Colors.white70 : Colors.black54,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  _buildSignUpButton(context, theme),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate back to the Login page
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.orangeAccent
                                : theme.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20), // Bottom spacing
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        // Basic validation
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        // Additional validation for email
        if (labelText == 'Email' &&
            !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.grey[200],
        labelText: labelText,
        prefixIcon:
            Icon(icon, color: isDarkMode ? Colors.white70 : Colors.black54),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.white24 : Colors.grey.shade400,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.orangeAccent : theme.primaryColor,
          ),
        ),
        labelStyle:
            TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            if (passwordController.text != confirmPasswordController.text) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Passwords do not match')),
              );
              return;
            }
            if (!termsAccepted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Please accept the terms and conditions')),
              );
              return;
            }
            // Perform signup logic
            // Navigate back to the login screen after successful signup
            Navigator.pop(context);
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isDarkMode ? Colors.orangeAccent : const Color(0xFFFF8C00),
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          elevation: 5,
          shadowColor: isDarkMode ? Colors.orangeAccent : theme.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        child: const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
