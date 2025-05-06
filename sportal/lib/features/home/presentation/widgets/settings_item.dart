import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';

class SettingsItem extends StatelessWidget {
  final AppTheme theme;
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget trailing;

  const SettingsItem({
    super.key,
    required this.theme,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
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
                    subtitle!,
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
