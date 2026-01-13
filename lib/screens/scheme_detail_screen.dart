import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/scheme.dart';
import '../models/user_profile.dart';
import '../logic/eligibility_engine.dart';
import '../logic/wishlist_provider.dart';
import '../l10n/app_localizations.dart';
import '../data/translation_service.dart';
import '../widgets/auto_translated_text.dart';

class SchemeDetailScreen extends StatelessWidget {
  final Scheme scheme;
  final UserProfile? userProfile;

  const SchemeDetailScreen({super.key, required this.scheme, this.userProfile});

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
      case "Aadhaar Card":
        return l10n.doc_aadhaar;

      case "PAN Card":
        return l10n.doc_pan;

      case "Land Record":
      case "Land Record (7/12)":
        return l10n.doc_land_record;
      case "Yield Certificate":
        return l10n.doc_yield_cert;
      case "Farm Proof":
        return l10n.doc_land_record; // heuristic

      case "Income Proof":
      case "Income Certificate":
        return l10n.doc_income_proof;
      case "Family Income Proof":
        return l10n.doc_income_proof;

      case "Rural Address Proof":
        return l10n.doc_rural_address;

      case "BPL Card":
      case "BPL Ration Card":
        return l10n.doc_bpl_card;

      case "Ration Card":
        return l10n.doc_ration_card;

      case "Age Proof":
      case "Child Age Proof":
        return l10n.doc_age_proof;

      case "Bank Account":
      case "Bank Passbook":
      case "Bank Account Proof":
        return l10n.doc_bank_account;

      case "Business Proof":
      case "Business Registration Proof":
        return l10n.doc_business_proof;

      case "Vendor ID":
      case "Street Vendor ID":
        return l10n.doc_vendor_id;

      case "School ID":
      case "School ID Card":
      case "College ID":
        return l10n.doc_school_id;

      case "Disability Certificate":
        return l10n.doc_disability_cert;

      case "Birth Certificate":
      case "Infant Birth Proof":
      case "Child Birth Proof":
        return l10n.doc_birth_cert;

      case "Electricity Bill":
      case "Electricity Connection":
        return l10n.doc_electricity_bill;

      case "Education Proof":
      case "Education Certificate":
      case "Degree Certificate":
      case "Marksheet":
        return l10n.doc_education_proof;

      case "Caste Certificate":
      case "Tribal Certificate":
        return l10n.doc_caste_cert;

      case "Residence Proof":
        return l10n.doc_residence_proof;

      case "Parents Aadhaar":
        return l10n.doc_parents_aadhaar;
      case "Mother Aadhaar":
        return l10n.doc_mother_aadhaar;

      case "Guardian ID":
        return l10n.doc_guardian_id;
      case "Pregnancy Proof":
      case "Pregnancy Registration":
      case "Pregnancy Registration Proof":
        return l10n.doc_pregnancy_proof;
      case "Marriage Certificate":
        return l10n.doc_marriage_cert;
      case "Death Certificate":
      case "Husband Death Certificate":
        return l10n.doc_death_cert;
      case "Medical Certificate":
      case "Medical Diagnosis":
      case "Doctor Recommendation":
      case "TB Test Report":
      case "Health Card":
      case "Immunization Card":
        return l10n.doc_medical_cert;

      case "Training Enrollment":
        return l10n.doc_training_enrollment;
      case "Self Declaration":
        return l10n.doc_self_declaration;

      case "Voter ID":
        return l10n.doc_voter_id;
      case "Driving License":
        return l10n.doc_driving_license;
      case "Passport":
        return l10n.doc_passport;
      case "Job Card":
      case "MGNREGA Job Card":
        return l10n.doc_job_card;
      case "SHG Resolution":
      case "SHG Registration":
        return l10n.doc_shg_resolution;
      case "Project Report":
      case "Project Approval":
      case "Project Enrollment":
        return l10n.doc_project_report;

      default:
        return docId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    // Use FutureBuilder to ensure we have translations even if static ones are missing
    return FutureBuilder<List<String>>(
      future: Future.wait([
        TranslationService().translate(
          scheme.translatedNames[locale] ?? scheme.name,
          locale,
        ),
        TranslationService().translate(
          scheme.translatedDescriptions[locale] ?? scheme.description,
          locale,
        ),
      ]),
      builder: (context, snapshot) {
        final name =
            snapshot.data?[0] ?? scheme.translatedNames[locale] ?? scheme.name;
        final description =
            snapshot.data?[1] ??
            scheme.translatedDescriptions[locale] ??
            scheme.description;

        return Scaffold(
          appBar: AppBar(
            title: Text(name), // Already translated or English
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
                // Header Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                        Text(
                          description,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                        // Benefit Amount Section
                        Builder(
                          builder: (context) {
                            bool isMissingOut = false;
                            if (userProfile != null) {
                              final result = EligibilityEngine.evaluate(
                                userProfile!,
                                scheme,
                              );
                              isMissingOut =
                                  result.status != EligibilityStatus.eligible;
                            }

                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isMissingOut
                                    ? Colors.orange.withValues(alpha: 0.1)
                                    : Colors.green.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isMissingOut
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                              child: Column(
                                children: [
                                  AutoTranslatedText(
                                    isMissingOut
                                        ? "You are missing out on"
                                        : "Potential Benefit",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: isMissingOut
                                          ? Colors.orange.shade800
                                          : Colors.green.shade800,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  AutoTranslatedText(
                                    scheme.benefitAmount,
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: isMissingOut
                                          ? Colors.orange
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            );
                          },
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
                    child: AutoTranslatedText(
                      l10n.btn_apply_now,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Eligibility Criteria (Dynamic)
                Builder(
                  builder: (context) {
                    if (userProfile == null) {
                      // Fallback to static rules display if no profile
                      return Column(
                        children: [
                          AutoTranslatedText(
                            "Eligibility Criteria",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: scheme.rules.entries.map((e) {
                                  return Row(
                                    children: [
                                      const Icon(
                                        Icons.info_outline,
                                        color: Colors.blue,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: AutoTranslatedText(
                                          "${e.key}: ${e.value}",
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    final result = EligibilityEngine.evaluate(
                      userProfile!,
                      scheme,
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (result.reasons.isNotEmpty) ...[
                          AutoTranslatedText(
                            "Why you are eligible",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: result.reasons
                                    .map(
                                      (r) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: AutoTranslatedText(
                                                r,
                                                style: TextStyle(fontSize: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        if (result.missing.isNotEmpty) ...[
                          AutoTranslatedText(
                            "What is missing",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: Colors.red.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: result.missing
                                    .map(
                                      (m) => Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 8.0,
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: AutoTranslatedText(
                                                m,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.red[800],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ],
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),

                // Required Documents Section
                Text(
                  l10n.required_documents,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: scheme.requiredDocuments
                      .map(
                        (doc) => Chip(
                          label: AutoTranslatedText(
                            _getLocalizedDocName(context, doc),
                          ),
                          backgroundColor: Colors.indigo.withValues(alpha: 0.1),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}
