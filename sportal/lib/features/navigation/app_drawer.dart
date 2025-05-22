import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';

class SportalDrawer extends StatelessWidget {
  final AppTheme theme;
  final String userName;
  final String email;
  final String avatarUrl;

  const SportalDrawer({
    super.key,
    required this.theme,
    required this.userName,
    required this.email,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: theme.drawerColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      elevation: 10,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.primaryColor, theme.secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(avatarUrl),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _buildDrawerItem(Icons.group, 'Teams', () {}),
          _buildDrawerItem(Icons.person, 'Players', () {}),
          _buildDrawerItem(Icons.sports_soccer, 'Matches', () {}),
          _buildDrawerItem(Icons.emoji_events, 'Tournaments', () {}),
          _buildDrawerItem(Icons.flag, 'Leagues', () {}),
          _buildDrawerItem(Icons.calendar_today, 'Calendar', () {}),
          _buildDrawerItem(Icons.account_circle, 'Profile', () {}),
          _buildDrawerItem(Icons.exit_to_app, 'Settings', () {}),
          const Divider(color: Colors.white24, height: 30),
          _buildDrawerItem(Icons.exit_to_app, 'Logout', () {Navigator.pushNamed(context, '/');}),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title, style: TextStyle(color: theme.primaryTextColor)),
      leading: Icon(icon, color: theme.primaryColor),
      onTap: onTap,
      hoverColor: theme.primaryColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
