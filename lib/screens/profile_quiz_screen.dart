import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import 'processing_screen.dart';
import '../widgets/option_card.dart';

class ProfileQuizScreen extends StatefulWidget {
  const ProfileQuizScreen({super.key});

  @override
  State<ProfileQuizScreen> createState() => _ProfileQuizScreenState();
}

class _ProfileQuizScreenState extends State<ProfileQuizScreen> {
  String? gender;
  String? occupation;
  String? locationType;

  int age = 25;
  double income = 100000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Profile Builder")),
      body: Column(
        children: [
          OptionCard(
            title: "Gender",
            options: ["male", "female"],
            onSelected: (v) => setState(() => gender = v),
          ),
          OptionCard(
            title: "Occupation",
            options: ["farmer", "student", "worker"],
            onSelected: (v) => setState(() => occupation = v),
          ),
          ElevatedButton(
            onPressed: () {
              final profile = UserProfile(
                gender: gender ?? "male",
                occupation: occupation ?? "student",
                locationType: "rural",
                age: age,
                income: income,
              );

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProcessingScreen(profile: profile),
                ),
              );
            },
            child: const Text("Find My Schemes"),
          )
        ],
      ),
    );
  }
}
