import 'package:flutter/material.dart';
import '../models/scheme.dart';
import '../widgets/scheme_card.dart';
import 'scheme_detail_screen.dart';
import 'wishlist_screen.dart';
import '../l10n/app_localizations.dart';

class DashboardScreen extends StatelessWidget {
  final List<Scheme> schemes;

  const DashboardScreen({super.key, required this.schemes});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.view_schemes_title),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            },
          ),
        ],
      ),
      body: schemes.isEmpty
          ? Center(child: Text(l10n.no_schemes_found))
          : ListView.builder(
              itemCount: schemes.length,
              itemBuilder: (_, i) {
                return SchemeCard(
                  scheme: schemes[i],
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SchemeDetailScreen(scheme: schemes[i]),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
