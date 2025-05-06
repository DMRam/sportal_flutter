import 'package:flutter/material.dart';
import 'package:sportal/features/home/home_screen.dart';

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
      home: const Sportal(),
      debugShowCheckedModeBanner: false,
    );
  }
}
