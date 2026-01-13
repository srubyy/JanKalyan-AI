// lib/screens/language_select_screen.dart

import 'package:flutter/material.dart';
import 'profile_quiz_screen.dart';
import '../data/translation_service.dart';

class LanguageSelectScreen extends StatefulWidget {
  final void Function(Locale) onLanguageSelected;
  final bool navigateAfterSelection;

  const LanguageSelectScreen({
    super.key,
    required this.onLanguageSelected,
    this.navigateAfterSelection = true,
  });

  @override
  State<LanguageSelectScreen> createState() => _LanguageSelectScreenState();
}

class _LanguageSelectScreenState extends State<LanguageSelectScreen> {
  bool _isLoading = false;
  String _loadingMessage = '';

  Future<void> _selectLanguage(BuildContext context, Locale locale) async {
    setState(() {
      _isLoading = true;
      _loadingMessage = 'Preparing language pack...';
    });

    try {
      // Initialize translation service and download model if needed
      await TranslationService().downloadModel(locale.languageCode);
    } catch (e) {
      debugPrint('Error downloading model: $e');
      // Continue anyway, maybe online translation will work or we fallback
    }

    widget.onLanguageSelected(locale);

    if (widget.navigateAfterSelection) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProfileQuizScreen()),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
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
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(color: Colors.white),
                      const SizedBox(height: 16),
                      Text(
                        _loadingMessage,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
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
