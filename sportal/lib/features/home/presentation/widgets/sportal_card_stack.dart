import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';
import 'package:sportal/features/home/presentation/widgets/sportal_card.dart';

class SportalCardStack extends StatefulWidget {
  final AppTheme theme;
  final List<SportalCardData> sportsData;

  const SportalCardStack({
    required this.theme,
    required this.sportsData,
    Key? key,
  }) : super(key: key);

  @override
  _SportalCardStackState createState() => _SportalCardStackState();
}

class _SportalCardStackState extends State<SportalCardStack> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 280, // Adjusted height to accommodate the card fully
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.sportsData.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  double value = 1.0;
                  if (_pageController.position.haveDimensions) {
                    value = _pageController.page! - index;
                    value = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
                  }

                  return Center(
                    child: SizedBox(
                      height: Curves.easeOut.transform(value) * 280,
                      width:
                          Curves.easeOut.transform(value) *
                          MediaQuery.of(context).size.width *
                          0.85,
                      child: child,
                    ),
                  );
                },
                child: SportalCard(
                  theme: widget.theme,
                  sport: widget.sportsData[index].sport,
                  skillRatings: widget.sportsData[index].skillRatings,
                  sportIcon: widget.sportsData[index].icon,
                  challengesCompleted:
                      widget.sportsData[index].challengesCompleted,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.sportsData.length,
            (index) => Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    _currentPage == index
                        ? widget.theme.primaryColor
                        : Colors.grey.withOpacity(0.4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// Data model for the cards
class SportalCardData {
  final String sport;
  final String icon;
  final Map<String, double> skillRatings;
  final int challengesCompleted;

  SportalCardData({
    required this.sport,
    required this.icon,
    required this.skillRatings,
    this.challengesCompleted = 0,
  });
}
