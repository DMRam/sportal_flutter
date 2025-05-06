import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';
import 'package:sportal/features/home/presentation/widgets/settings_item.dart';

class SettingsTab extends StatelessWidget {
  final AppTheme theme;
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  
  const SettingsTab({
    super.key,
    required this.theme,
    required this.isDarkMode,
    required this.toggleTheme,
  });

  @override
  Widget build(BuildContext context) {
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
                    SettingsItem(
                      theme: theme,
                      icon: Icons.notifications,
                      title: 'Notifications',
                      trailing: Switch(
                        value: true,
                        onChanged: (value) {},
                        activeColor: theme.primaryColor,
                      ),
                    ),
                    SettingsItem(
                      theme: theme,
                      icon: Icons.privacy_tip,
                      title: 'Privacy',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: theme.secondaryTextColor,
                      ),
                    ),
                    SettingsItem(
                      theme: theme,
                      icon: Icons.help,
                      title: 'Help & Support',
                      trailing: Icon(
                        Icons.chevron_right,
                        color: theme.secondaryTextColor,
                      ),
                    ),
                    SettingsItem(
                      theme: theme,
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
                    SettingsItem(
                      theme: theme,
                      icon: Icons.palette,
                      title: 'App Theme',
                      subtitle: isDarkMode ? 'Dark' : 'Light',
                      trailing: IconButton(
                        icon: Icon(
                          isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                          color: theme.primaryColor,
                        ),
                        onPressed: toggleTheme,
                      ),
                    ),
                    SettingsItem(
                      theme: theme,
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
}