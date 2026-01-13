import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../logic/wishlist_provider.dart';
import '../data/schemes.dart';
import '../l10n/app_localizations.dart';
import 'scheme_detail_screen.dart';
import '../data/translation_service.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.wishlist_title)),
      body: const WishlistBody(),
    );
  }
}

class WishlistBody extends StatelessWidget {
  const WishlistBody({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    return Consumer<WishlistProvider>(
      builder: (context, wishlistProvider, child) {
        final wishlistedIds = wishlistProvider.wishlistedSchemeIds;
        if (wishlistedIds.isEmpty) {
          return Center(
            child: Text(
              l10n.no_wishlist_items,
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          );
        }

        final wishlistedSchemes = schemesDatabase
            .where((s) => wishlistedIds.contains(s.id))
            .toList();

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: wishlistedSchemes.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final scheme = wishlistedSchemes[index];

            // Localized Name & Description (Attempt static first)
            final name = scheme.translatedNames[locale] ?? scheme.name;
            final description =
                scheme.translatedDescriptions[locale] ?? scheme.description;

            // Use FutureBuilder to translate if needed (for fallback to English content)
            // Even if we have a static translation, we can just pass it through.
            // The TranslationService handles 'en' -> 'en' efficiently.

            return FutureBuilder<List<String>>(
              future: Future.wait([
                TranslationService().translate(name, locale),
                TranslationService().translate(description, locale),
              ]),
              builder: (context, snapshot) {
                final displayTitle = snapshot.data?[0] ?? name;
                final displayDesc = snapshot.data?[1] ?? description;

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            SchemeDetailScreen(scheme: scheme),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  displayTitle,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  wishlistProvider.removeFromWishlist(
                                    scheme.id,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            displayDesc,
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () =>
                                  _launchUrl(scheme.applicationUrl),
                              child: Text(l10n.btn_apply_now),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
