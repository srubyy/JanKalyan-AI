import 'package:flutter/material.dart';
import 'wishlist_screen.dart';
import 'language_select_screen.dart';
import 'profile_quiz_screen.dart';
import '../l10n/app_localizations.dart';

class ReturningUserScreen extends StatelessWidget {
  final void Function(Locale) onLanguageSelected;

  const ReturningUserScreen({super.key, required this.onLanguageSelected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.wishlist_title)),
      body: Column(
        children: [
          const Expanded(child: WishlistBody()),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.language),
                      label: const Text(
                        "Change Language",
                      ), // Using hardcoded string as fallback/default
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => LanguageSelectScreen(
                              navigateAfterSelection: false,
                              onLanguageSelected: (locale) {
                                onLanguageSelected(locale);
                                Navigator.pop(
                                  context,
                                ); // Go back after selection
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.assignment),
                      label: const Text("Retake Profile Quiz"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileQuizScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
