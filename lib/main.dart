import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'l10n/app_localizations_en.dart';

import 'package:provider/provider.dart';
import 'logic/wishlist_provider.dart';
import 'screens/language_select_screen.dart';

import 'data/schemes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/wishlist_screen.dart';
import 'screens/profile_quiz_screen.dart';

// ... imports

// Custom Delegate that supports all locales but returns English strings (which we then dynamically translate)
class CustomLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi', 'mr', 'gu'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // Always load English strings as the base for translation,
    // but tell it that it's the requested locale so Localizations.localeOf() works correctly.
    return AppLocalizationsEn(locale.languageCode);
  }

  @override
  bool shouldReload(CustomLocalizationsDelegate old) => false;
}

// ... other imports ...

// ... imports

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadSchemesFromLocalDb();
  
  final prefs = await SharedPreferences.getInstance();
  final bool hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
  final String? savedLanguageCode = prefs.getString('kLanguageCode');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishlistProvider()..loadWishlist()),
      ],
      child: JanKalyanApp(
        startOnboarding: !hasCompletedOnboarding,
        initialLanguageCode: savedLanguageCode,
      ),
    ),
  );
}

class JanKalyanApp extends StatefulWidget {
  final bool startOnboarding;
  final String? initialLanguageCode;

  const JanKalyanApp({
    super.key, 
    required this.startOnboarding,
    this.initialLanguageCode,
  });

  static void setLocale(BuildContext context, Locale newLocale) {
    _JanKalyanAppState? state = context
        .findAncestorStateOfType<_JanKalyanAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<JanKalyanApp> createState() => _JanKalyanAppState();
}

class _JanKalyanAppState extends State<JanKalyanApp> {
  Locale? _locale;

  @override
  void initState() {
    super.initState();
    if (widget.initialLanguageCode != null) {
      _locale = Locale(widget.initialLanguageCode!);
    }
  }

  void setLocale(Locale locale) async {
    print("DEBUG: Setting locale to ${locale.languageCode}");
    setState(() {
      _locale = locale;
    });
    
    // Save to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('kLanguageCode', locale.languageCode);
  }
// ... build method remains same ...

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JanKalyan AI',
      locale: _locale,

      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),

      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('mr'),
        Locale('gu'),
      ],
      localizationsDelegates: const [
        CustomLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // Navigation Logic
      // If we need to start onboarding, go to LanguageSelectScreen
      // Otherwise, go straight to WishlistScreen (Main Dashboard)
      home: widget.startOnboarding 
          ? LanguageSelectScreen(onLanguageSelected: setLocale)
          : const WishlistScreen(),
      
      routes: {
        '/language': (context) => LanguageSelectScreen(onLanguageSelected: setLocale),
        '/quiz': (context) => const ProfileQuizScreen(),
        '/home': (context) => const WishlistScreen(),
      },
    );
  }
}
