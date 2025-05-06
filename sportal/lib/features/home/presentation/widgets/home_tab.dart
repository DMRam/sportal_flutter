import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';
import 'package:sportal/features/home/presentation/widgets/counter_card.dart';
import 'package:sportal/features/home/presentation/widgets/sportal_card.dart';
import 'package:sportal/features/home/presentation/widgets/sportal_card_stack.dart';
import 'package:sportal/features/home/presentation/widgets/stat_card_row.dart';

Widget buildHomeTab(AppTheme theme) {
  // Define your sports data
  final sportsData = [
    SportalCardData(
      sport: 'Futsal',
      icon: '⚽',
      skillRatings: {'Pase': 3.8, 'Defensa': 4.2, 'Regate': 3.5, 'Tiro': 4.0},
      challengesCompleted: 12,
    ),
    SportalCardData(
      sport: 'Volleyball',
      icon: '🏐',
      skillRatings: {
        'Saque': 3.2,
        'Bloqueo': 3.8,
        'Remate': 4.1,
        'Recepcion': 3.5,
      },
      challengesCompleted: 8,
    ),
    // Add more sports as needed
  ];

  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header Card
          _buildHeaderCard(theme),

          const SizedBox(height: 20),

          // Stats Cards Row
          _buildStatsRow(theme),

          const SizedBox(height: 20),

          // Sports Cards Carousel
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(
                  'Sportal Cards',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryTextColor,
                  ),
                ),
              ),
              SportalCardStack(theme: theme, sportsData: sportsData),
            ],
          ),

          const SizedBox(height: 20),

          // You can keep your CounterCard here if needed
          // CounterCard(theme: theme),
        ],
      ),
    ),
  );
}

Widget _buildHeaderCard(AppTheme theme) {
  return Card(
    color: theme.cardColor,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: theme.primaryColor,
                child: const Icon(Icons.person, size: 30, color: Colors.white),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome back,',
                    style: TextStyle(
                      color: theme.secondaryTextColor,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Athlete!',
                    style: TextStyle(
                      color: theme.primaryTextColor,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            'Ready to dominate today? Track your progress and crush your goals!',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.secondaryTextColor, fontSize: 16),
          ),
        ],
      ),
    ),
  );
}

// This would be nice to connect with an watch or fitness tracker API
// to fetch real-time data
// and display it here.
Widget _buildStatsRow(AppTheme theme) {
  return Row(
    children: [
      Expanded(
        child: StatCard(
          theme: theme,
          icon: Icons.build,
          value: 'Tools',
          unit: 'km',
          label: 'Distance',
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: StatCard(
          theme: theme,
          icon: Icons.leaderboard,
          value: '1:45',
          unit: 'hrs',
          label: 'Time',
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: StatCard(
          theme: theme,
          icon: Icons.local_fire_department,
          value: '1,250',
          unit: 'cal',
          label: 'Burned',
        ),
      ),
    ],
  );
}


// Cards before the StatCardRow
// This is the original code for the stats row
/**
 * Expanded(
        child: StatCard(
          theme: theme,
          icon: Icons.directions_run,
          value: '12.5',
          unit: 'km',
          label: 'Distance',
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: StatCard(
          theme: theme,
          icon: Icons.timer,
          value: '1:45',
          unit: 'hrs',
          label: 'Time',
        ),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: StatCard(
          theme: theme,
          icon: Icons.local_fire_department,
          value: '1,250',
          unit: 'cal',
          label: 'Burned',
        ),
      ),
 */