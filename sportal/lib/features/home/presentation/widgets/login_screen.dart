import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';

class LoginScreen extends StatelessWidget {
  final AppTheme theme;

  const LoginScreen({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarColor,
        title: Text(
          'Login',
          style: TextStyle(color: theme.primaryTextColor),
        ),
        iconTheme: IconThemeData(color: theme.primaryTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              style: TextStyle(color: theme.primaryTextColor),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: theme.secondaryTextColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.secondaryColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: TextStyle(color: theme.primaryTextColor),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: theme.secondaryTextColor),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.secondaryColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: theme.primaryColor),
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: theme.buttonTextColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () {
                  // TODO: Implement login logic
                },
                child: const Text('Login'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
