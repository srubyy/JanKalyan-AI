
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/scheme.dart';
import '../logic/wishlist_provider.dart';
import '../l10n/app_localizations.dart';

class SchemeDetailScreen extends StatelessWidget {
  final Scheme scheme;

  const SchemeDetailScreen({super.key, required this.scheme});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  String _getLocalizedDocName(BuildContext context, String docId) {
    final l10n = AppLocalizations.of(context)!;
    switch (docId) {
      case "Aadhaar": return l10n.doc_aadhaar;
      case "PAN Card": return l10n.doc_pan;
      case "Land Record": return l10n.doc_land_record;
      case "Income Proof": return l10n.doc_income_proof;
      case "Rural Address Proof": return l10n.doc_rural_address;
      case "BPL Card": return l10n.doc_bpl_card;
      case "Ration Card": return l10n.doc_ration_card;
      case "Age Proof": return l10n.doc_age_proof;
      case "Bank Account": return l10n.doc_bank_account;
      case "Business Proof": return l10n.doc_business_proof;
      case "Vendor ID": return l10n.doc_vendor_id;
      case "School ID": return l10n.doc_school_id;
      case "Disability Certificate": return l10n.doc_disability_cert;
      case "Birth Certificate": return l10n.doc_birth_cert;
      case "Electricity Bill": return l10n.doc_electricity_bill;
      case "Education Proof": return l10n.doc_education_proof;
      default: return docId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    
    final name = scheme.translatedNames[locale] ?? scheme.name;
    final description = scheme.translatedDescriptions[locale] ?? scheme.description;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              final isWishlisted = wishlistProvider.isWishlisted(scheme.id);
              return IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  if (isWishlisted) {
                    wishlistProvider.removeFromWishlist(scheme.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.btn_remove_wishlist)),
                    );
                  } else {
                    wishlistProvider.addToWishlist(scheme.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.btn_add_wishlist)),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      floatingActionButton: Consumer<WishlistProvider>(
        builder: (context, wishlistProvider, child) {
          final isWishlisted = wishlistProvider.isWishlisted(scheme.id);
          return FloatingActionButton(
            onPressed: () {
              if (isWishlisted) {
                wishlistProvider.removeFromWishlist(scheme.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.btn_remove_wishlist)),
                );
              } else {
                wishlistProvider.addToWishlist(scheme.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.btn_add_wishlist)),
                );
              }
            },
            backgroundColor: Colors.white,
            child: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.red : Colors.grey,
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 16),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Apply Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => _launchUrl(scheme.applicationUrl),
                child: Text(
                  l10n.btn_apply_now,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Required Documents Section
            Text(
              l10n.required_documents,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: scheme.requiredDocuments.map((doc) => Chip(
                label: Text(_getLocalizedDocName(context, doc)),
                backgroundColor: Colors.indigo.withValues(alpha: 0.1),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
