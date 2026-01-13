// lib/screens/language_select_screen.dart

import 'package:flutter/material.dart';
import 'profile_quiz_screen.dart';

class LanguageSelectScreen extends StatelessWidget {
  final void Function(Locale) onLanguageSelected;
  final VoidCallback? onNext;

  const LanguageSelectScreen({
    super.key, 
    required this.onLanguageSelected,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.language, size: 80, color: Colors.blue),
                const SizedBox(height: 48),
                _LanguageButton(
                  label: 'English',
                  onTap: () => _selectLanguage(context, const Locale('en')),
                ),
                const SizedBox(height: 16),
                _LanguageButton(
                  label: 'हिंदी',
                  onTap: () => _selectLanguage(context, const Locale('hi')),
                ),
                const SizedBox(height: 16),
                _LanguageButton(
                  label: 'मराठी',
                  onTap: () => _selectLanguage(context, const Locale('mr')),
                ),
                const SizedBox(height: 16),
                _LanguageButton(
                  label: 'ગુજરાતી',
                  onTap: () => _selectLanguage(context, const Locale('gu')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectLanguage(BuildContext context, Locale locale) {
    onLanguageSelected(locale);
    
    if (onNext != null) {
      onNext!();
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const ProfileQuizScreen()),
      );
    }
  }
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LanguageButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 72,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
