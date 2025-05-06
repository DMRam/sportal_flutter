import 'package:flutter/material.dart';

class ScoreCounter extends StatefulWidget {
  const ScoreCounter({super.key});

  @override
  State<ScoreCounter> createState() => _ScoreCounterState();
}

class _ScoreCounterState extends State<ScoreCounter> 
    with SingleTickerProviderStateMixin {
  int _counter = 0;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Score: $_counter', 
                style: const TextStyle(fontSize: 24, color: Colors.white)),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
              ),
              onPressed: () => setState(() => _counter++),
              child: const Text('Add Point'),
            ),
          ],
        ),
      ),
    );
  }
}