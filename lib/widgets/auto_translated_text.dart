import 'package:flutter/material.dart';
import '../data/translation_service.dart';

class AutoTranslatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  const AutoTranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();

    final locale = Localizations.localeOf(context).languageCode;

    // If English, return plain text
    if (locale == 'en') {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      );
    }

    // Heuristic: If text contains non-ASCII characters, it's likely already localized
    // This prevents translating "लिंग" (Hindi) as if it were English -> Hindi
    final isAscii = RegExp(r'^[\x00-\x7F]+$').hasMatch(text);
    if (!isAscii) {
      return Text(
        text,
        style: style,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
      );
    }

    return FutureBuilder<String>(
      future: TranslationService().translate(text, locale),
      builder: (context, snapshot) {
        final translatedText = snapshot.data ?? text;
        return Text(
          translatedText,
          style: style,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
        );
      },
    );
  }
}
