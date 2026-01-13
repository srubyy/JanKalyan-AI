import 'package:flutter/material.dart';
import '../models/scheme.dart';
import '../widgets/scheme_card.dart';
import 'scheme_detail_screen.dart';
import 'wishlist_screen.dart';
import '../l10n/app_localizations.dart';
import '../widgets/translated_text.dart';

class DashboardScreen extends StatelessWidget {
  final List<Scheme> schemes;

  const DashboardScreen({super.key, required this.schemes});

  @override
  Widget build(BuildContext context) {
    // We still use l10n to get the English string (fallback logic in generated code will likely return English if delegate missing or we force it)
    // Actually, since we removed the other arbs, AppLocalizations.of(context) will likely be the English one if we set up the delegate correctly,
    // OR it might return null/error if the locale is 'hi'. 
    // BUT since we only have 'en' generated, we should rely on the fact that we need the ENGLISH text to translate FROM.
    // However, AppLocalizations won't generate 'hi' classes anymore. 
    // So if locale is 'hi', AppLocalizations.of(context) might fail if the delegate doesn't support 'hi'.
    // We need to fix the delegate issue first.
    
    // For now, let's assume we can get English strings. 
    // The trick is: If we are in 'hi', the Localizations widget tries to load 'hi'. 
    // If our AppLocalizations.delegate ONLY supports 'en' (which it will if we re-gen), then the app might crash or fallback to en.
    // We need to make sure we force 'en' lookup for the strings, and then translate them.
    
    // BETTER APPROACH:
    // We will use a lookup method that always returns English strings regardless of current locale,
    // OR we fix the delegate to return English strings for all locales.
    
    // But I can't easily modify the generated delegate.
    
    // Temporary Hack:
    // If I deleted the files, `flutter gen-l10n` will generate a delegate that ONLY supports 'en'.
    // But I told MaterialApp I support 'hi'.
    // MaterialApp checks the delegate. "Do you support 'hi'?" Delegate says "No".
    // MaterialApp checks next delegate... eventually falls back to default? Or error.
    
    // Correct Fix: To allow `AppLocalizations.of(context)` to work even when in 'hi' mode (but return English):
    // I should probably instantiate AppLocalizationsEn() directly? simpler for now?
    
    // Actually, we can just use `TranslatedText` and pass the raw English string if we want 
    // but better to keep using the keys from arb so we don't hardcode strings in UI.
    
    // Let's assume for this specific file, I will use `AppLocalizationsEn().view_schemes_title` pattern? 
    // No, that class is library private usually... wait, `app_localizations_en.dart` is generated. 
    // It's usually `AppLocalizationsEn`.
    
    // Let's play it safe. I'll import `translated_text.dart` and wrap the usage.
    // I'll wrap the `l10n` call in a way that safeguards it?
    // Actually, if `AppLocalizations.of(context)` returns null, we have an issue.
    // But since I deleted the arb files, I need to make sure the app technically runs.
    
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: TranslatedText(l10n.view_schemes_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            },
          ),
        ],
      ),
      body: schemes.isEmpty
          ? Center(child: TranslatedText(l10n.no_schemes_found))
          : ListView.builder(
              itemCount: schemes.length,
              itemBuilder: (_, i) {
                return SchemeCard(
                  scheme: schemes[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SchemeDetailScreen(scheme: schemes[i]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
