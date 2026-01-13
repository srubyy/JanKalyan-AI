
import 'package:flutter/material.dart';
import '../logic/translation_service.dart';

/// A widget that displays translated text dynamically based on the current app locale.
class TranslatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  State<TranslatedText> createState() => _TranslatedTextState();
}

class _TranslatedTextState extends State<TranslatedText> {
  String? _translatedText;
  String? _currentLocale;
  String? _originalText;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAndTranslate();
  }

  @override
  void didUpdateWidget(TranslatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _checkAndTranslate();
    }
  }

  Future<void> _checkAndTranslate() async {
    final locale = Localizations.localeOf(context).languageCode;
    
    // If locale changed or text changed, reset
    if (_currentLocale != locale || _originalText != widget.text) {
      _currentLocale = locale;
      _originalText = widget.text;
      
      if (locale == 'en') {
        if (mounted) {
          setState(() {
            _translatedText = widget.text;
          });
        }
        return;
      }

      print("DEBUG: TranslatedText attempting translation. Locale: $locale, Text: '${widget.text}'");
      // Start translation
      try {
        final result = await TranslationService.translate(widget.text, locale);
        print("DEBUG: TranslatedText result: '$result'");
        if (mounted && _originalText == widget.text && _currentLocale == locale) {
          setState(() {
            _translatedText = result;
          });
        }
      } catch (e) {
        debugPrint('Error translating "${widget.text}": $e');
        // Fallback to original
        if (mounted) {
          setState(() {
            _translatedText = widget.text;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _translatedText ?? widget.text, // Show original while loading? or maybe a shimmering placeholder
      style: widget.style,
      textAlign: widget.textAlign,
      maxLines: widget.maxLines,
      overflow: widget.overflow,
    );
  }
}
