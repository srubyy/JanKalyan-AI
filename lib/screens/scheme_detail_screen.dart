
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/scheme.dart';
import '../logic/wishlist_provider.dart';
import '../l10n/app_localizations.dart';
import '../logic/translation_service.dart';
import '../widgets/translated_text.dart';

class SchemeDetailScreen extends StatefulWidget {
  final Scheme scheme;

  const SchemeDetailScreen({super.key, required this.scheme});

  @override
  State<SchemeDetailScreen> createState() => _SchemeDetailScreenState();
}

class _SchemeDetailScreenState extends State<SchemeDetailScreen> {
  bool _isTranslating = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkAndTranslate();
  }

  Future<void> _checkAndTranslate() async {
    final locale = Localizations.localeOf(context).languageCode;
    
    if (locale == 'en') return;
    if (widget.scheme.translatedNames.containsKey(locale) && 
        widget.scheme.translatedDescriptions.containsKey(locale)) {
      return;
    }

    if (_isTranslating) return;

    // Optional: Only start translating if not already available
    // But we might want to trigger it.
    
    setState(() {
      _isTranslating = true;
    });

    try {
      final nameFuture = widget.scheme.translatedNames.containsKey(locale)
          ? Future.value(widget.scheme.translatedNames[locale]!)
          : TranslationService.translate(widget.scheme.name, locale);

      final descFuture = widget.scheme.translatedDescriptions.containsKey(locale)
          ? Future.value(widget.scheme.translatedDescriptions[locale]!)
          : TranslationService.translate(widget.scheme.description, locale);

      final results = await Future.wait([nameFuture, descFuture]);

      if (mounted) {
        setState(() {
          widget.scheme.translatedNames[locale] = results[0];
          widget.scheme.translatedDescriptions[locale] = results[1];
          _isTranslating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isTranslating = false);
      }
      debugPrint("Translation error in details: $e");
    }
  }

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

// ... imports

  // Helper to parse description and notes
  Map<String, String> _parseDescription(String rawDescription) {
    if (rawDescription.contains('Note:')) {
      final parts = rawDescription.split('Note:');
      return {
        'desc': parts[0].trim(),
        'note': 'Note: ${parts[1].trim()}',
      };
    }
    return {'desc': rawDescription, 'note': ''};
  }

  Widget _buildEligibilityItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TranslatedText(
              text,
              style: const TextStyle(fontSize: 15, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEligibilityList(Map<String, dynamic> rules) {
    List<Widget> items = [];
    
    // Age
    if (rules.containsKey('minAge') || rules.containsKey('maxAge')) {
      items.add(_buildEligibilityItem("Age requirement satisfied"));
    }
    
    // Gender
    if (rules.containsKey('gender')) {
       // We can be more specific if we want, e.g., "Eligible as Female"
       items.add(_buildEligibilityItem("Gender eligible"));
    }
    
    // Income
    if (rules.containsKey('maxIncome')) {
      items.add(_buildEligibilityItem("Income criteria met"));
    }

    // State
    if (rules.containsKey('state')) {
      items.add(_buildEligibilityItem("State residency verified"));
    }

    // Occupation
    if (rules.containsKey('occupation')) {
      items.add(_buildEligibilityItem("Occupation checks out"));
    }
    
    // Category
    if (rules.containsKey('category') || rules.containsKey('specialCategory')) {
      items.add(_buildEligibilityItem("Category eligible"));
    }

    // Default if no rules (universal scheme)
    if (items.isEmpty) {
      items.add(_buildEligibilityItem("Open to all eligible citizens"));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    
    final name = widget.scheme.translatedNames[locale] ?? widget.scheme.name;
    final rawDescription = widget.scheme.translatedDescriptions[locale] ?? widget.scheme.description;
    
    final parsedDesc = _parseDescription(rawDescription);
    final description = parsedDesc['desc']!;
    final note = parsedDesc['note']!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FA), // Light greyish background
      appBar: AppBar(
        title: Text(name, style: const TextStyle(color: Colors.black87, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        centerTitle: true,
        actions: [
          Consumer<WishlistProvider>(
            builder: (context, wishlistProvider, child) {
              final isWishlisted = wishlistProvider.isWishlisted(widget.scheme.id);
              return IconButton(
                icon: Icon(
                  isWishlisted ? Icons.favorite : Icons.favorite_border,
                  color: isWishlisted ? Colors.red : Colors.grey, // Matching image style
                ),
                onPressed: () {
                  if (isWishlisted) {
                    wishlistProvider.removeFromWishlist(widget.scheme.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: TranslatedText(l10n.btn_remove_wishlist)),
                    );
                  } else {
                    wishlistProvider.addToWishlist(widget.scheme.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: TranslatedText(l10n.btn_add_wishlist)),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Header Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Title
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A4E9C), // Slate/Indigo color
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Description
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.5,
                    ),
                  ),
                  
                  if (note.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      note,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),

                  // Potential Benefit Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9), // Light green bg
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                         const TranslatedText(
                           "Potential Benefit", // You might want to add this to .arb if strict checks needed, but fallback works
                           style: TextStyle(
                             color: Colors.green,
                             fontWeight: FontWeight.w600,
                             fontSize: 12,
                           ),
                         ),
                        const SizedBox(height: 4),
                        // Benefit Amount
                        TranslatedText(
                          widget.scheme.benefitAmount.isEmpty ? "See details" : widget.scheme.benefitAmount,
                          style: const TextStyle(
                            color: Colors.green, // Darker green
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 2. Apply Button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51B5), // Indigo
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                onPressed: () => _launchUrl(widget.scheme.applicationUrl),
                child: TranslatedText(
                  l10n.btn_apply_now,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            const SizedBox(height: 32),

            // 3. Why you are eligible
            const TranslatedText(
              "Why you are eligible",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F0F7), // Light purple/grey
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: _buildEligibilityList(widget.scheme.rules),
              ),
            ),

            const SizedBox(height: 32),

            // 4. Required Documents
            TranslatedText(
              l10n.required_documents,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12.0,
              runSpacing: 12.0,
              children: widget.scheme.requiredDocuments.map((doc) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6), // Light indigo tint
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.indigo.withOpacity(0.1)),
                ),
                child: TranslatedText(
                  _getLocalizedDocName(context, doc),
                  style: const TextStyle(color: Color(0xFF3F51B5), fontWeight: FontWeight.w500),
                ),
              )).toList(),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Consumer<WishlistProvider>(
          builder: (context, wishlistProvider, child) {
            final isWishlisted = wishlistProvider.isWishlisted(widget.scheme.id);
            return FloatingActionButton(
              onPressed: () {
                if (isWishlisted) {
                  wishlistProvider.removeFromWishlist(widget.scheme.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: TranslatedText(l10n.btn_remove_wishlist)),
                  );
                } else {
                  wishlistProvider.addToWishlist(widget.scheme.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: TranslatedText(l10n.btn_add_wishlist)),
                  );
                }
              },
              backgroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
              child: Icon(
                isWishlisted ? Icons.favorite : Icons.favorite_border,
                color: isWishlisted ? Colors.red : Colors.grey,
              ),
            );
          },
        ),
      ),
    );
  }
}
