import 'package:flutter/material.dart';

class ProgressRing extends StatelessWidget {
  final double progress;

  const ProgressRing({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      value: progress,
      strokeWidth: 8,
    );
  }
}
