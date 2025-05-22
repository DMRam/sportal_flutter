import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';

class WelcomeScreen extends StatefulWidget {
  final DarkTheme theme;
  const WelcomeScreen({super.key, required this.theme});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  static final List<String> sportsImages = [
    'https://as2.ftcdn.net/jpg/00/45/51/17/1000_F_45511756_baLXjUDYvCKZsBNsKR0dAzCzOQMcgAe7.jpg', // Basketball
    'https://media.gettyimages.com/id/166008628/vector/volleyball-serve-design-girls.jpg?s=1024x1024&w=gi&k=20&c=n3o39ihI1Tnw_bv79sJWcDWHPKFTNFuieSP6iglE5d0=', // Stadium
    'https://previews.123rf.com/images/arija07/arija071802/arija07180200039/96103721-football-player-running-with-the-ball-illustration-on-white-background.jpg', // Soccer
    'https://thumbs.dreamstime.com/b/tennis-player-silhouette-abstract-racket-splash-watercolors-vector-illustration-paints-98730899.jpg', // Runners
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < sportsImages.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Stack(
          children: [
            // Background Slideshow
            PageView.builder(
              controller: _pageController,
              itemCount: sportsImages.length,
              itemBuilder: (context, index) {
                return Image.network(
                  sportsImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text("Image failed to load"));
                  },
                );
              },
            ),

            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(128, 228, 3, 100),
                      Color.fromARGB(61, 0, 0, 0),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
            ),

            // UI Content
            SafeArea(
              child: Column(
                children: [
                  const Spacer(flex: 3),
                  const Icon(
                    Icons.sports_soccer_outlined,
                    color:  Color.fromARGB(217, 255, 255, 255),
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to Sportal',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      color: const Color.fromARGB(255, 169, 185, 248),
                      shadows: [
                        Shadow(
                          blurRadius: 10,
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.8),
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Your portal to all sports',
                    style: TextStyle(fontSize: 18, color: const Color.fromARGB(217, 255, 255, 255), fontWeight: FontWeight.w900,),
                  ),
                  const Spacer(flex: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(192, 207, 64, 255),
                          foregroundColor: const Color.fromARGB(
                            255,
                            58,
                            55,
                            55,
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
