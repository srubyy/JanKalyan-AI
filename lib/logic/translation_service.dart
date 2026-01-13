import 'dart:async';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class TranslationService {
  // Cache to store translated results to prevent repeated work
  static final Map<String, Map<String, String>> _cache = {};
  
  // Model Manager to handle model downloads
  static final _modelManager = OnDeviceTranslatorModelManager();
  
  // Cache translators to ensure we don't recreate them needlessly
  // Key: target language bcpCode
  static final Map<String, OnDeviceTranslator> _translators = {};

  // Lock to prevent concurrent model downloads for the same language
  static final Map<String, Completer<void>> _downloadingModels = {};

  /// Translates text to the target language code using on-device ML Kit.
  /// Downloads the model if not present.
  /// Returns the original text if translation fails.
  static Future<String> translate(String text, String targetLang) async {
    if (text.isEmpty) return text;
    if (targetLang == 'en') return text;

    // Check memory cache first
    if (_cache.containsKey(targetLang) && _cache[targetLang]!.containsKey(text)) {
      return _cache[targetLang]![text]!;
    }

    try {
      final targetLanguage = _getLanguage(targetLang);
      if (targetLanguage == null) {
        // Unsupported language
        return text;
      }

      // Ensure model is ready
      await _ensureModelDownloaded(targetLanguage);

      // Get translator
      final translator = _getTranslator(targetLanguage);
      
      final translatedText = await translator.translateText(text);

      // Cache result
      if (!_cache.containsKey(targetLang)) {
        _cache[targetLang] = {};
      }
      _cache[targetLang]![text] = translatedText;
      
      return translatedText;
    } catch (e) {
      print("Translation Error for '$targetLang': $e");
      return text;
    }
  }

  static Future<void> _ensureModelDownloaded(TranslateLanguage language) async {
    final bcpCode = language.bcpCode;
    
    // Check if fully downloaded first
    if (await _modelManager.isModelDownloaded(bcpCode)) return;

    // Check if currently downloading
    if (_downloadingModels.containsKey(bcpCode)) {
      await _downloadingModels[bcpCode]!.future;
      return;
    }

    final completer = Completer<void>();
    _downloadingModels[bcpCode] = completer;

    try {
      print("Downloading translation model for $bcpCode... (Requires Internet)");
      final bool success = await _modelManager.downloadModel(bcpCode);
      if (success) {
         print("Model for $bcpCode downloaded successfully.");
         completer.complete();
      } else {
         print("CRITICAL: Failed to download model for $bcpCode. Check internet connection.");
         completer.completeError("Download failed - Check Internet Connection");
      }
    } catch (e) {
      print("Failed to download model $bcpCode: $e");
      completer.completeError(e);
      rethrow; 
    } finally {
      _downloadingModels.remove(bcpCode);
    }
  }

  static OnDeviceTranslator _getTranslator(TranslateLanguage targetLanguage) {
    final key = targetLanguage.bcpCode;
    if (_translators.containsKey(key)) {
      return _translators[key]!;
    }

    final translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: targetLanguage,
    );
    _translators[key] = translator;
    return translator;
  }

  static TranslateLanguage? _getLanguage(String code) {
    try {
      return TranslateLanguage.values.firstWhere(
        (l) => l.bcpCode == code,
      );
    } catch (_) {
      return null;
    }
  }
}
