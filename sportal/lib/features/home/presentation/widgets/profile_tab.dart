import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';
import 'package:sportal/features/home/presentation/widgets/achievements_items.dart';

class ProfileTab extends StatelessWidget {
  final AppTheme theme;

  const ProfileTab({super.key, required this.theme});

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
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                theme.primaryColor,
                                theme.secondaryColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primaryColor.withOpacity(0.3),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.backgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: theme.primaryColor,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'John Athlete',
                      style: TextStyle(
                        color: theme.primaryTextColor,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Professional Runner',
                      style: TextStyle(
                        color: theme.secondaryTextColor,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildProfileStat(
                          theme,
                          value: '125',
                          label: 'Workouts',
                        ),
                        _buildProfileStat(
                          theme,
                          value: '12.5k',
                          label: 'Steps',
                        ),
                        _buildProfileStat(theme, value: '98', label: 'Score'),
                      ],
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Achievements',
                      style: TextStyle(
                        color: theme.primaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    AchievementItem(
                      theme: theme,
                      icon: Icons.emoji_events,
                      title: 'Marathon Finisher',
                      subtitle: 'Completed your first marathon',
                      color: Colors.amber,
                    ),
                    AchievementItem(
                      theme: theme,
                      icon: Icons.directions_run,
                      title: 'Speed Demon',
                      subtitle: 'Ran 5km under 20 minutes',
                      color: Colors.blue,
                    ),
                    AchievementItem(
                      theme: theme,
                      icon: Icons.star,
                      title: 'Consistency King',
                      subtitle: '30 days workout streak',
                      color: Colors.purple,
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

  Widget _buildProfileStat(
    AppTheme theme, {
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: theme.primaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: theme.secondaryTextColor, fontSize: 12),
        ),
      ],
    );
  }
}
