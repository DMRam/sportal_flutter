import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';

class SportalBottomNavBar extends StatelessWidget {
  final AppTheme theme;
  final int currentIndex;
  final Function(int) onTap;

  const SportalBottomNavBar({
    super.key,
    required this.theme,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavBarColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BottomNavigationBar(
        backgroundColor:
            theme.bottomNavBarColor, // Set this to match the container color
        elevation: 0,
        selectedItemColor: theme.primaryColor,
        unselectedItemColor: theme.secondaryTextColor,
        showSelectedLabels: true, // Show selected labels
        showUnselectedLabels: true, // Show unselected labels
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.bottomNavBarColor,
              ),
              child: const Icon(Icons.home),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.bottomNavBarColor,
              ),
              child: const Icon(Icons.notifications_active),
            ),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: theme.bottomNavBarColor,
              ),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
            label: 'Shopping',
          ),
        ],
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }
}
