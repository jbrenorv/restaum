import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size(400.0, 400.0)),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
            ),
            children: List<Widget>.generate(
              49,
              (index) => Container(
                decoration: BoxDecoration(
                  color: _getColorByIndex(index),
                  shape: BoxShape.circle,
                ),
                margin: const EdgeInsets.all(4.0),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _getColorByIndex(int index) =>
      _isIndexValid(index) ? Colors.red : Colors.transparent;

  bool _isIndexValid(int index) {
    final x = index % 7;
    final y = index ~/ 7;
    return ((x > 1 && x < 5) || (y > 1 && y < 5));
  }
}
