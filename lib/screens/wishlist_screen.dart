import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../logic/wishlist_provider.dart';
import '../data/schemes.dart';
import '../models/scheme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/translated_text.dart';
import '../logic/translation_service.dart';
import '../main.dart';
import 'language_select_screen.dart';
import 'scheme_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: TranslatedText(l10n.wishlist_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip:
                "Retake Quiz", // Localize if possible, but tooltip is minor
            onPressed: () {
              Navigator.of(context).pushNamed('/quiz');
            },
          ),
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: "Change Language",
            onPressed: () {
              // Push LanguageSelectScreen directly so we can define onNext behavior
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LanguageSelectScreen(
                    onLanguageSelected: (locale) =>
                        JanKalyanApp.setLocale(context, locale),
                    onNext: () => Navigator.of(context).pop(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, child) {
          final wishlistedIds = wishlistProvider.wishlistedSchemeIds;
          final wishlistedSchemes = schemesDatabase
              .where((s) => wishlistedIds.contains(s.id))
              .toList();

          return Column(
            children: [
              // 1. Top Actions Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                color: Colors.grey[100],
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.refresh, size: 18),
                        label: const TranslatedText(
                          "Retake Profile Quiz",
                          style: TextStyle(fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.deepPurple,
                          side: const BorderSide(color: Colors.deepPurple),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/quiz');
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.language, size: 18),
                        label: const TranslatedText(
                          "Change Language",
                          style: TextStyle(fontSize: 13),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.indigo,
                          side: const BorderSide(color: Colors.indigo),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LanguageSelectScreen(
                                onLanguageSelected: (locale) =>
                                    JanKalyanApp.setLocale(context, locale),
                                onNext: () => Navigator.of(context).pop(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Wishlist Content
              Expanded(
                child: wishlistedIds.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            const SizedBox(height: 16),
                            TranslatedText(
                              l10n.no_wishlist_items,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: wishlistedSchemes.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          return _WishlistSchemeCard(
                            scheme: wishlistedSchemes[index],
                            onRemove: () => wishlistProvider.removeFromWishlist(
                              wishlistedSchemes[index].id,
                            ),
                            onApply: () => _launchUrl(
                              wishlistedSchemes[index].applicationUrl,
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => SchemeDetailScreen(
                                    scheme: wishlistedSchemes[index],
                                  ),
                                ),
                              );
                            },
                            l10n: l10n,
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _WishlistSchemeCard extends StatefulWidget {
  final Scheme scheme;
  final VoidCallback onRemove;
  final VoidCallback onApply;
  final VoidCallback onTap;
  final AppLocalizations l10n;

  const _WishlistSchemeCard({
    required this.scheme,
    required this.onRemove,
    required this.onApply,
    required this.onTap,
    required this.l10n,
  });

  @override
  State<_WishlistSchemeCard> createState() => _WishlistSchemeCardState();
}

class _WishlistSchemeCardState extends State<_WishlistSchemeCard> {
  // Similar logic to SchemeCard for translation

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAndTranslate();
  }

  Future<void> _checkAndTranslate() async {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'en') return;

    // Check if already translated
    if (widget.scheme.translatedNames.containsKey(locale) &&
        widget.scheme.translatedDescriptions.containsKey(locale))
      return;

    try {
      final nameTask = TranslationService.translate(widget.scheme.name, locale);
      final descTask = TranslationService.translate(
        widget.scheme.description,
        locale,
      );

      final results = await Future.wait([nameTask, descTask]);

      if (mounted) {
        setState(() {
          widget.scheme.translatedNames[locale] = results[0];
          widget.scheme.translatedDescriptions[locale] = results[1];
        });
      }
    } catch (e) {
      debugPrint("Wishlist Translation Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final name = widget.scheme.translatedNames[locale] ?? widget.scheme.name;
    final desc =
        widget.scheme.translatedDescriptions[locale] ??
        widget.scheme.description;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias, // Ensure ripple is clipped
      child: InkWell(
        onTap: widget.onTap,
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
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.grey),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(desc, style: TextStyle(color: Colors.grey[700])),
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
                onPressed: widget.onApply,
                child: TranslatedText(widget.l10n.btn_apply_now),
              ),
            ),
          ],

        ),
      ),
    ),
    );
  }
}
