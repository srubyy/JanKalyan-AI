import 'package:flutter/material.dart';
import '../models/scheme.dart';
import '../l10n/app_localizations.dart';
import '../logic/translation_service.dart';
import 'translated_text.dart';

class SchemeCard extends StatefulWidget {
  final Scheme scheme;
  final VoidCallback? onTap;

  const SchemeCard({super.key, required this.scheme, this.onTap});

  @override
  State<SchemeCard> createState() => _SchemeCardState();
}

class _SchemeCardState extends State<SchemeCard> {
  bool _isTranslating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAndTranslate();
  }

  @override
  void didUpdateWidget(SchemeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.scheme != widget.scheme) {
      _checkAndTranslate();
    }
  }

  Future<void> _checkAndTranslate() async {
    final locale = Localizations.localeOf(context).languageCode;
    
    // If English, or already translated, no need to do anything
    if (locale == 'en') return;
    if (widget.scheme.translatedNames.containsKey(locale) && 
        widget.scheme.translatedDescriptions.containsKey(locale)) {
      return;
    }

    if (_isTranslating) return;

    setState(() {
      _isTranslating = true;
    });

    try {
      final nameFuture = widget.scheme.translatedNames.containsKey(locale)
          ? Future.value(widget.scheme.translatedNames[locale]!)
          : TranslationService.translate(widget.scheme.name, locale);

      final descFuture = widget.scheme.translatedDescriptions.containsKey(locale)
          ? Future.value(widget.scheme.translatedDescriptions[locale]!)
          : TranslationService.translate(widget.scheme.description, locale);

      final results = await Future.wait([nameFuture, descFuture]);

      if (mounted) {
        setState(() {
          widget.scheme.translatedNames[locale] = results[0];
          widget.scheme.translatedDescriptions[locale] = results[1];
          _isTranslating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isTranslating = false);
      }
      debugPrint("Translation error in card: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    
    final name = widget.scheme.translatedNames[locale] ?? widget.scheme.name;
    final description = widget.scheme.translatedDescriptions[locale] ?? widget.scheme.description;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
          onTap: widget.onTap,
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
                        color: Colors.indigo.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.description, color: Colors.indigo, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              height: 1.3,
                            ),
                          ),
                          if (_isTranslating)
                           Padding(
                             padding: const EdgeInsets.only(top: 4.0),
                             child: LinearProgressIndicator(minHeight: 2, color: Colors.indigo.withOpacity(0.3)),
                           )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  description,
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
                    TranslatedText(
                      l10n.view_details,
                      style: const TextStyle(
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
  }
}
