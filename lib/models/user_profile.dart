import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class UserProfile {
  final String gender;
  final String occupation;
  final String locationType;
  final int age;
  final double income;

  UserProfile({
    required this.gender,
    required this.occupation,
    required this.locationType,
    required this.age,
    required this.income,
    this.socialCategory,
    this.specialCategory,
    this.state,
    this.landOwnership,
  });

  final String? socialCategory;
  final String? specialCategory;
  final String? state;
  final String? landOwnership;
}

class SmartProfileBuilder extends StatefulWidget {
  const SmartProfileBuilder({super.key});

  @override
  State<SmartProfileBuilder> createState() => _SmartProfileBuilderState();
}

class _SmartProfileBuilderState extends State<SmartProfileBuilder> {
  String selectedGender = "male";
  String selectedOccupation = "farmer";
  String selectedLocationType = "rural";
  int selectedAge = 25;
  double selectedIncome = 15000.0;

  final Color primaryColor = const Color(0xFF6200EE);

  void _submitProfile() {
    final user = UserProfile(
      gender: selectedGender,
      occupation: selectedOccupation,
      locationType: selectedLocationType,
      age: selectedAge,
      income: selectedIncome,
    );

    developer.log(
      'Profile Created: ${user.occupation} from ${user.locationType}',
    );
  }

  Widget _buildIconOption<T>({
    required T value,
    required T groupValue,
    required IconData icon,
    required String label,
    required Function(T) onTap,
  }) {
    bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? primaryColor : Colors.grey,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? primaryColor : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Smart Profile Builder"),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Occupation",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildIconOption(
                  value: "farmer",
                  groupValue: selectedOccupation,
                  icon: Icons.agriculture,
                  label: "Farmer",
                  onTap: (v) => setState(() => selectedOccupation = v),
                ),
                _buildIconOption(
                  value: "student",
                  groupValue: selectedOccupation,
                  icon: Icons.school,
                  label: "Student",
                  onTap: (v) => setState(() => selectedOccupation = v),
                ),
                _buildIconOption(
                  value: "worker",
                  groupValue: selectedOccupation,
                  icon: Icons.engineering,
                  label: "Worker",
                  onTap: (v) => setState(() => selectedOccupation = v),
                ),
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _submitProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Find My Schemes",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
