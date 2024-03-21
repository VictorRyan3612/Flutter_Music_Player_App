import 'package:flutter/material.dart';

class MusicPlayingScreen extends StatelessWidget {
  late Offset _initialPosition;

  static const double _minSwipeDistance = 100.0;

  MusicPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        body: Center(child: Text('Texto'),),
      ),
      
      onVerticalDragStart: (details) {
        _initialPosition = details.globalPosition;
      },
      onVerticalDragUpdate: (details) {
        final distance = details.globalPosition.dy - _initialPosition.dy;

        if (distance > _minSwipeDistance) {
          Navigator.pop(context);
        }
      },
    );
  }
}
