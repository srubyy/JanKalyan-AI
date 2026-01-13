import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

// Helper for translation logic
class TranslationService {
  final _modelManager = OnDeviceTranslatorModelManager();

  // Cache translators to avoid re-creating them constantly
  static final Map<String, OnDeviceTranslator> _translators = {};

  Future<bool> isModelDownloaded(String languageCode) async {
    final language = _getTranslateLanguage(languageCode);
    if (language == null) return false;
    return await _modelManager.isModelDownloaded(language.bcpCode);
  }

  Future<void> downloadModel(String languageCode) async {
    final language = _getTranslateLanguage(languageCode);
    if (language != null) {
      await _modelManager.downloadModel(language.bcpCode);
    }
  }

  Future<String> translate(String text, String targetLanguageCode) async {
    // If source is English and target is English, return original
    if (targetLanguageCode == 'en') return text;

    // We assume source text is in English for schemes
    const sourceLanguage = TranslateLanguage.english;
    final targetLanguage = _getTranslateLanguage(targetLanguageCode);

    if (targetLanguage == null) return text;

    final key = '${sourceLanguage.bcpCode}_${targetLanguage.bcpCode}';

    if (!_translators.containsKey(key)) {
      _translators[key] = OnDeviceTranslator(
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      );
    }

    try {
      return await _translators[key]!.translateText(text);
    } catch (e) {
      debugPrint('Translation error: $e');
      return text;
    }
  }

  TranslateLanguage? _getTranslateLanguage(String code) {
    switch (code) {
      case 'hi':
        return TranslateLanguage.hindi;
      case 'mr':
        return TranslateLanguage.marathi;
      case 'gu':
        return TranslateLanguage.gujarati;
      case 'en':
        return TranslateLanguage.english;
      default:
        return null;
    }
  }
}
