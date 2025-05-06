import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isDarkMode = true;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme =
        _isDarkMode ? DarkTheme() : LightTheme(); // Use your theme classes

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: theme.appBarColor,
      ),
      backgroundColor: theme.backgroundColor,
      body: _buildSettingsTab(theme), // Your settings tab widget
    );
  }

  Widget _buildSettingsTab(AppTheme theme) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              color: theme.cardColor,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      theme,
                      icon: Icons.notifications,
                      title: 'Notifications',
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: theme.primaryColor,
                      ),
                    ),
                    _buildSettingsItem(
                      theme,
                      icon: Icons.privacy_tip,
                      title: 'Privacy',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: theme.secondaryTextColor,
                      ),
                    ),
                    _buildSettingsItem(
                      theme,
                      icon: Icons.help,
                      title: 'Help & Support',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: theme.secondaryTextColor,
                      ),
                    ),
                    _buildSettingsItem(
                      theme,
                      icon: Icons.info,
                      title: 'About',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: theme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              color: theme.cardColor,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      theme,
                      icon: Icons.palette,
                      title: 'App Theme',
                      subtitle: _isDarkMode ? 'Dark' : 'Light',
                      trailing: IconButton(
                        icon: Icon(
                          _isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                          color: theme.primaryColor,
                        ),
                        onPressed: _toggleTheme,
                      ),
                    ),
                    _buildSettingsItem(
                      theme,
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: 'English',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: theme.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsItem(
    AppTheme theme, {
    required IconData icon,
    required String title,
    String? subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, color: theme.primaryColor),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: theme.primaryTextColor)),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: theme.secondaryTextColor,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
