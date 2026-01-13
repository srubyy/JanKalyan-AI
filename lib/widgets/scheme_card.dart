import 'package:flutter/material.dart';
import '../models/scheme.dart';
import '../l10n/app_localizations.dart';
import '../data/translation_service.dart';

class SchemeCard extends StatelessWidget {
  final Scheme scheme;
  final VoidCallback? onTap;

  const SchemeCard({super.key, required this.scheme, this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    // Attempt to get pre-seeded translation first
    String name = scheme.translatedNames[locale] ?? scheme.name;
    String description =
        scheme.translatedDescriptions[locale] ?? scheme.description;

    // If we only have English but user wants another language, assume we need ML translation
    // We can do this calculation in FutureBuilder below or just pass the text to a FutureBuilder wrapper

    return FutureBuilder<List<String>>(
      future: Future.wait([
        TranslationService().translate(name, locale),
        TranslationService().translate(description, locale),
      ]),
      builder: (context, snapshot) {
        final translatedName = snapshot.data?[0] ?? name;
        final translatedDesc = snapshot.data?[1] ?? description;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.indigo.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.description,
                            color: Colors.indigo,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            translatedName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      translatedDesc,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          l10n.view_details,
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
