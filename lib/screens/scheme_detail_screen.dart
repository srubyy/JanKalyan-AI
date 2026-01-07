import 'package:flutter/material.dart';
import '../models/scheme.dart';
import '../logic/readiness_engine.dart';
import '../widgets/progress_ring.dart';

class SchemeDetailScreen extends StatelessWidget {
  final Scheme scheme;

  const SchemeDetailScreen({super.key, required this.scheme});

  @override
  Widget build(BuildContext context) {
    final userDocs = ["Aadhaar Card"]; // stub for demo
    final score = ReadinessEngine.readinessScore(userDocs, scheme);

    return Scaffold(
      appBar: AppBar(title: Text(scheme.name)),
      body: Column(
        children: [
          Text(scheme.description),
          ProgressRing(progress: score / 100),
          Text("Missing: ${ReadinessEngine.missingDocuments(userDocs, scheme)}"),
        ],
      ),
    );
  }
}
