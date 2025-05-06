import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';

class TopTabBar extends StatelessWidget implements PreferredSizeWidget {
  final AppTheme theme;

  const TopTabBar({super.key, required this.theme});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight - 4);
  // Slightly slimmer than the full AppBar, feels more balanced for TabBar

  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(width: 3, color: theme.primaryColor),
        insets: const EdgeInsets.symmetric(horizontal: 24),
      ),
      labelColor: theme.primaryTextColor,
      unselectedLabelColor: theme.secondaryTextColor.withOpacity(0.6),
      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      tabs: const [
        Tab(icon: Icon(Icons.home), text: 'Tools'),
        Tab(icon: Icon(Icons.leaderboard), text: 'Rankings'),
        Tab(icon: Icon(Icons.card_membership), text: 'Sportal Card'),
      ],
    );
  }
}
