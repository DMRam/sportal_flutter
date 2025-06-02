import 'package:flutter/material.dart';
import 'package:sportal/core/app_theme.dart';
import 'package:sportal/features/home/home_screen.dart';
import 'package:sportal/features/home/presentation/widgets/login_screen.dart';
import 'package:sportal/features/home/presentation/widgets/registration_screen.dart';
import 'package:sportal/features/home/presentation/widgets/welcome_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => WelcomeScreen(theme: DarkTheme()),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(theme: DarkTheme()),
        );
      case '/dashboard':
        return MaterialPageRoute(builder: (_) => const Sportal());
      case '/register':
        return MaterialPageRoute(
          builder: (_) => RegistrationScreen(theme: DarkTheme()),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
