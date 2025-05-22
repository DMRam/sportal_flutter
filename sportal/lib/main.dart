import 'package:flutter/material.dart';
import 'package:sportal/core/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sportal',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      initialRoute: '/', 
      onGenerateRoute: AppRouter.generateRoute, 
      debugShowCheckedModeBanner: false,
    );
  }
}
