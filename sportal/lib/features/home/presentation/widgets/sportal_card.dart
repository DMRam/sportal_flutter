import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';

class SportalCard extends StatelessWidget {
  final AppTheme theme;
  final String sport;
  final Map<String, double> skillRatings;
  final String sportIcon;
  final int challengesCompleted;
  final VoidCallback? onChallengesPressed;

  const SportalCard({
    required this.theme,
    required this.sport,
    required this.skillRatings,
    this.sportIcon = '⚽',
    this.challengesCompleted = 0,
    this.onChallengesPressed,
    Key? key,
  }) : super(key: key);

  String getCategory(double average) {
    if (average < 1.5) return 'Rookie';
    if (average < 2.0) return 'Beginner';
    if (average < 2.5) return 'Intermediate';
    if (average < 3.0) return 'Advanced';
    if (average < 3.5) return 'Expert';
    if (average < 4.0) return 'Elite';
    return 'Professional';
  }

  Color getCategoryColor(double average) {
    if (average < 1.5) return Colors.grey;
    if (average < 2.0) return Colors.blue;
    if (average < 2.5) return Colors.green;
    if (average < 3.0) return Colors.yellow[700]!;
    if (average < 3.5) return Colors.orange;
    if (average < 4.0) return Colors.red;
    return Colors.purple;
  }

  @override
  Widget build(BuildContext context) {
    final averageRating =
        skillRatings.values.fold(0.0, (a, b) => a + b) / skillRatings.length;
    final category = getCategory(averageRating);
    final categoryColor = getCategoryColor(averageRating);

    return Card(
      color: theme.cardColor,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Sport Icon with gradient background
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [theme.primaryColor, theme.secondaryColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primaryColor.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        sportIcon,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sport.toUpperCase(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.primaryTextColor,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.emoji_events,
                            size: 16,
                            color: categoryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            category,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: categoryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Rating summary with stars
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Level',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.secondaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              averageRating.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: theme.primaryTextColor,
                              ),
                            ),
                            const SizedBox(width: 8),
                            ...List.generate(5, (index) {
                              double starValue = index + 1;
                              return Icon(
                                starValue <= averageRating
                                    ? Icons.star
                                    : starValue - 0.5 <= averageRating
                                    ? Icons.star_half
                                    : Icons.star_border,
                                color: categoryColor,
                                size: 20,
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Challenges',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.secondaryTextColor,
                          ),
                        ),
                        Text(
                          challengesCompleted.toString(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Skills breakdown
              Text(
                'Evaluated Skills',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryTextColor,
                ),
              ),
              const SizedBox(height: 8),
              ...skillRatings.entries.map((e) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e.key,
                            style: TextStyle(color: theme.primaryTextColor),
                          ),
                          Text(
                            e.value.toStringAsFixed(1),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: theme.primaryTextColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: e.value / 5,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(3),
                        backgroundColor: theme.backgroundColor,
                        color: categoryColor,
                      ),
                    ],
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),

              // Challenges button - Improved for dark mode
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: theme.cardColor, // Better contrast
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 2,
                  ),
                  onPressed: onChallengesPressed,
                  child: Text(
                    'View $category Level Challenges',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.buttonTextColor ?? Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
