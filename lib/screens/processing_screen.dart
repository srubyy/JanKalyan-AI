import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../data/schemes.dart';
import '../logic/eligibility_engine.dart';
import 'dashboard_screen.dart';

class ProcessingScreen extends StatelessWidget {
  final UserProfile profile;

  const ProcessingScreen({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final eligibleSchemes = schemesDatabase
        .where((scheme) => EligibilityEngine.isEligible(profile, scheme))
        .toList();

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text("View Results"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      DashboardScreen(schemes: eligibleSchemes)),
            );
          },
        ),
      ),
    );
  }
}
