import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sportal/core/app_theme.dart';
import 'package:sportal/features/home/presentation/widgets/floating_action_button.dart';
import 'package:sportal/features/home/presentation/widgets/home_tab.dart';
import 'package:sportal/features/home/presentation/widgets/profile_tab.dart';
import 'package:sportal/features/home/presentation/widgets/setting_tab.dart';
import 'package:sportal/features/navigation/app_drawer.dart';
import 'package:sportal/features/navigation/bottom_nav.dart';
import 'package:sportal/features/navigation/top_nav.dart';

class Sportal extends StatefulWidget {
  const Sportal({super.key});

  @override
  State<Sportal> createState() => _SportalScreenState();
}

class _SportalScreenState extends State<Sportal>
    with SingleTickerProviderStateMixin {
  int counter = 0;
  int _currentIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _rotateAnimation;
  bool _isDarkMode = true;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _colorAnimation = ColorTween(
      begin: Colors.deepPurpleAccent,
      end: Colors.amber,
    ).animate(_animationController);

    _rotateAnimation = Tween<double>(begin: 0, end: 0.25).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // Start animation on first build
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      counter++;
      _showEventCreationDialog(context); // Open event creation dialog
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<void> _showEventCreationDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Create Sportal Event'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Event Type Dropdown
                DropdownButton<String>(
                  items:
                      <String>[
                        'Match',
                        'Challenge',
                        'Tournament',
                        'League',
                      ].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (String? value) {
                    // Update event type
                  },
                  hint: const Text('Select Event Type'),
                ),
                const SizedBox(height: 10),
                // Event Name TextField
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Event Name',
                    hintText: 'Enter the event name',
                  ),
                ),
                const SizedBox(height: 10),
                // Event Date Picker
                ElevatedButton(
                  onPressed: () {
                    // Implement DatePicker logic here
                  },
                  child: const Text('Select Date'),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  // Save event logic
                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _isDarkMode ? DarkTheme() : LightTheme();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: theme.backgroundColor,
        appBar: AppBar(
          toolbarHeight: 90,
          iconTheme: IconThemeData(
            color:
                Theme.of(context).brightness == Brightness.light
                    ? Colors.deepPurpleAccent
                    : Colors.white,
          ),
          backgroundColor: theme.appBarColor,
          title: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Text(
              'SPORTAL',
              key: ValueKey<bool>(_isDarkMode),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.5,
                color: theme.primaryTextColor,
                shadows: [
                  Shadow(
                    blurRadius: 10,
                    color: theme.primaryColor.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child:
                    _isDarkMode
                        ? const Icon(Icons.wb_sunny, key: ValueKey('sun'))
                        : const Icon(
                          Icons.nightlight_round,
                          key: ValueKey('moon'),
                        ),
              ),
              onPressed: _toggleTheme,
            ),
          ],
          // bottom: TopTabBar(theme: theme),
        ),
        drawer: SportalDrawer(
          theme: theme,
          userName: 'Danny Sportal',
          email: 'danny@sportal.com',
          avatarUrl: 'https://your-avatar-url.com/avatar.png',
        ),
        bottomNavigationBar: SportalBottomNavBar(
          theme: theme,
          currentIndex: _currentIndex,
          onTap: _onBottomNavTap,
        ),
        body: TabBarView(
          children: [
            // Tab 1: Home
            buildHomeTab(theme),

            // Tab 2: Profile
            ProfileTab(theme: theme),

            // Tab 3: Settings
            SettingsTab(
              theme: theme,
              isDarkMode: _isDarkMode,
              toggleTheme: _toggleTheme,
            ),
          ],
        ),
        floatingActionButton: SportalFloatingActionButton(
          theme: theme,
          showEventDialog:
              true, // This will make it show the dialog when pressed
        ),
        // Optional: Position the FAB
        floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      ),
    );
  }
}
