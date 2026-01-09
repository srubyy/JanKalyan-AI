import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

import 'package:provider/provider.dart';
import 'logic/wishlist_provider.dart';
import 'screens/language_select_screen.dart';

import 'data/schemes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadSchemesFromLocalDb();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WishlistProvider()..loadWishlist()),
      ],
      child: const JanKalyanApp(),
    ),
  );
}

class JanKalyanApp extends StatefulWidget {
  const JanKalyanApp({super.key});

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

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'JanKalyan AI',
      locale: _locale,

      // 🎨 Theme (you can keep this)
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),

      // 🌐 MULTILINGUAL CONFIG (MOST IMPORTANT)
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // 🏠 First screen
      home: LanguageSelectScreen(onLanguageSelected: setLocale),
    );
  }
}
