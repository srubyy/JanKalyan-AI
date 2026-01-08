import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import '../models/user_profile.dart';

class ProfileQuizScreen extends StatefulWidget {
  const ProfileQuizScreen({super.key});

  @override
  State<ProfileQuizScreen> createState() => _ProfileQuizScreenState();
}

class _ProfileQuizScreenState extends State<ProfileQuizScreen> {
  // Profile Variables
  String selectedGender = "male";
  String selectedOccupation = "farmer";
  String selectedLocationType = "rural";
  int selectedAge = 25;

  // Income Logic
  String incomeType = "monthly"; 
  double selectedIncome = 15000.0;
  late TextEditingController _incomeController;

  final Color primaryColor = const Color(0xFF6200EE);

  @override
  void initState() {
    super.initState();
    _incomeController = TextEditingController(text: selectedIncome.round().toString());
  }

  @override
  void dispose() {
    _incomeController.dispose();
    super.dispose();
  }

  double get _getMaxIncome {
    if (incomeType == "daily") return 5000.0;
    if (incomeType == "yearly") return 1200000.0;
    return 100000.0; // monthly
  }

  void _updateIncome(double value) {
    setState(() {
      selectedIncome = value;
      _incomeController.text = value.round().toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text("Smart Profile Builder", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader("Gender"),
            _buildGenderRow(),
            
            const SizedBox(height: 30),
            _sectionHeader("Occupation"),
            _buildOccupationWrap(),

            const SizedBox(height: 30),
            _sectionHeader("Income Details"),
            
            // Income Type Toggle
            Center(
              child: SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'daily', label: Text('Daily')),
                  ButtonSegment(value: 'monthly', label: Text('Monthly')),
                  ButtonSegment(value: 'yearly', label: Text('Yearly')),
                ],
                selected: {incomeType},
                onSelectionChanged: (newSelection) {
                  setState(() {
                    incomeType = newSelection.first;
                    _updateIncome(incomeType == 'daily' ? 500 : (incomeType == 'yearly' ? 200000 : 15000));
                  });
                },
              ),
            ),

            const SizedBox(height: 20),
            Slider(
              value: selectedIncome.clamp(0, _getMaxIncome),
              min: 0,
              max: _getMaxIncome,
              activeColor: primaryColor,
              onChanged: _updateIncome,
            ),

            TextField(
              controller: _incomeController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                labelText: "Enter ${incomeType[0].toUpperCase()}${incomeType.substring(1)} Income (₹)",
                prefixText: "₹ ",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) {
                double? val = double.tryParse(value);
                if (val != null) {
                  setState(() => selectedIncome = val.clamp(0, _getMaxIncome));
                }
              },
            ),

            const SizedBox(height: 40),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // --- Helper UI Methods ---

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildGenderRow() {
    return Row(
      children: [
        _buildSelectionCard(value: "male", groupValue: selectedGender, icon: Icons.male, label: "Male", onTap: () => setState(() => selectedGender = "male")),
        const SizedBox(width: 15),
        _buildSelectionCard(value: "female", groupValue: selectedGender, icon: Icons.female, label: "Female", onTap: () => setState(() => selectedGender = "female")),
      ],
    );
  }

  Widget _buildOccupationWrap() {
    return Wrap(
      spacing: 15,
      runSpacing: 15,
      children: [
        _buildSelectionCard(value: "farmer", groupValue: selectedOccupation, icon: Icons.agriculture, label: "Farmer", onTap: () => setState(() => selectedOccupation = "farmer")),
        _buildSelectionCard(value: "student", groupValue: selectedOccupation, icon: Icons.school, label: "Student", onTap: () => setState(() => selectedOccupation = "student")),
        _buildSelectionCard(value: "worker", groupValue: selectedOccupation, icon: Icons.engineering, label: "Worker", onTap: () => setState(() => selectedOccupation = "worker")),
        _buildSelectionCard(value: "artisan", groupValue: selectedOccupation, icon: Icons.brush, label: "Artisan", onTap: () => setState(() => selectedOccupation = "artisan")),
      ],
    );
  }

  Widget _buildSelectionCard<T>({required T value, required T groupValue, required IconData icon, required String label, required VoidCallback onTap}) {
    bool isSelected = value == groupValue;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 105,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? primaryColor : Colors.grey.shade200, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? primaryColor : Colors.grey.shade600, size: 30),
            const SizedBox(height: 10),
            Text(label, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? primaryColor : Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          final user = UserProfile(
            gender: selectedGender,
            occupation: selectedOccupation,
            locationType: selectedLocationType,
            age: selectedAge,
            income: selectedIncome, 
          );
          developer.log("Profile Build: ${user.occupation}, Income: ${user.income}");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: const Text("Find My Schemes", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }
}