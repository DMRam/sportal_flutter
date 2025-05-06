import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.theme,
    required this.icon,
    required this.value,
    required this.unit,
    required this.label,
  });

  final AppTheme theme;
  final IconData icon;
  final String value;
  final String unit;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: theme.cardColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: theme.primaryColor, size: 24),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      color: theme.primaryTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: TextStyle(
                      color: theme.secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(color: theme.secondaryTextColor, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
