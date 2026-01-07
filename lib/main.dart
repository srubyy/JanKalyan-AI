import 'package:flutter/material.dart';
import 'screens/profile_quiz_screen.dart';

void main() {
  runApp(const JanKalyanApp());
}

class JanKalyanApp extends StatelessWidget {
  const JanKalyanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JanKalyan AI',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const ProfileQuizScreen(),
    );
  }
}
