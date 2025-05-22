import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';

class LoginScreen extends StatelessWidget {
  final AppTheme theme;

  const LoginScreen({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Logo or Title
                  Center(
                    child: Text(
                      'Welcome Back 👋',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: theme.primaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Login to your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.secondaryTextColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email Field
                  TextField(
                    controller: emailController,
                    style: TextStyle(color: theme.primaryTextColor),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: theme.secondaryTextColor),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: theme.secondaryTextColor,
                      ),
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    style: TextStyle(color: theme.primaryTextColor),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: theme.secondaryTextColor),
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: theme.secondaryTextColor,
                      ),
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // TODO
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Login Button
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/dashboard');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: theme.buttonTextColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: theme.secondaryTextColor)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'or continue with',
                          style: TextStyle(color: theme.secondaryTextColor),
                        ),
                      ),
                      Expanded(child: Divider(color: theme.secondaryTextColor)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Social Login Button
                  SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // TODO: Google sign-in
                      },
                      icon: Icon(
                        Icons.g_mobiledata,
                        color: theme.primaryColor,
                        size: 30,
                      ),
                      label: Text(
                        'Google',
                        style: TextStyle(
                          color: theme.primaryTextColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.primaryColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Sign up hint
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // TODO: Navigate to sign-up screen
                      },
                      child: RichText(
                        text: TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: theme.secondaryTextColor),
                          children: [
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
