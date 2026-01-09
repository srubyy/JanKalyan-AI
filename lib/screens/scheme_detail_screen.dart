
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
    // Map DB string -> Arb key
    // NOTE: DB strings must match exactly
    switch (docId) {
      case "Aadhaar": 
      case "Aadhaar Card": return l10n.doc_aadhaar;
      
      case "PAN Card": return l10n.doc_pan;
      
      case "Land Record": 
      case "Land Record (7/12)": return l10n.doc_land_record;
      case "Yield Certificate": return l10n.doc_yield_cert;
      case "Farm Proof": return l10n.doc_land_record; // heuristic
      
      case "Income Proof": 
      case "Income Certificate": return l10n.doc_income_proof;
      case "Family Income Proof": return l10n.doc_income_proof;
      
      case "Rural Address Proof": return l10n.doc_rural_address;
      
      case "BPL Card": 
      case "BPL Ration Card": return l10n.doc_bpl_card;
      
      case "Ration Card": return l10n.doc_ration_card;
      
      case "Age Proof": 
      case "Child Age Proof": return l10n.doc_age_proof;
      
      case "Bank Account": 
      case "Bank Passbook": 
      case "Bank Account Proof": return l10n.doc_bank_account;
      
      case "Business Proof": 
      case "Business Registration Proof": return l10n.doc_business_proof;
      
      case "Vendor ID": 
      case "Street Vendor ID": return l10n.doc_vendor_id;
      
      case "School ID": 
      case "School ID Card": 
      case "College ID": return l10n.doc_school_id;
      
      case "Disability Certificate": return l10n.doc_disability_cert;
      
      case "Birth Certificate": 
      case "Infant Birth Proof": 
      case "Child Birth Proof": return l10n.doc_birth_cert;
      
      case "Electricity Bill": 
      case "Electricity Connection": return l10n.doc_electricity_bill;
      
      case "Education Proof": 
      case "Education Certificate": 
      case "Degree Certificate":
      case "Marksheet": return l10n.doc_education_proof;

      case "Caste Certificate": 
      case "Tribal Certificate": return l10n.doc_caste_cert;

      case "Residence Proof": return l10n.doc_residence_proof;
      
      case "Parents Aadhaar": return l10n.doc_parents_aadhaar;
      case "Mother Aadhaar": return l10n.doc_mother_aadhaar;
      
      case "Guardian ID": return l10n.doc_guardian_id;
      case "Pregnancy Proof": 
      case "Pregnancy Registration":
      case "Pregnancy Registration Proof": return l10n.doc_pregnancy_proof;
      case "Marriage Certificate": return l10n.doc_marriage_cert;
      case "Death Certificate": 
      case "Husband Death Certificate": return l10n.doc_death_cert;
      case "Medical Certificate": 
      case "Medical Diagnosis": 
      case "Doctor Recommendation": 
      case "TB Test Report": 
      case "Health Card": 
      case "Immunization Card": return l10n.doc_medical_cert;
      
      case "Training Enrollment": return l10n.doc_training_enrollment;
      case "Self Declaration": return l10n.doc_self_declaration;
      
      case "Voter ID": return l10n.doc_voter_id;
      case "Driving License": return l10n.doc_driving_license;
      case "Passport": return l10n.doc_passport;
      case "Job Card": 
      case "MGNREGA Job Card": return l10n.doc_job_card;
      case "SHG Resolution": 
      case "SHG Registration": return l10n.doc_shg_resolution;
      case "Project Report": 
      case "Project Approval": 
      case "Project Enrollment": return l10n.doc_project_report;

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
