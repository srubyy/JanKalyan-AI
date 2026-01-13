import 'package:hive_flutter/hive_flutter.dart';
import '../models/scheme.dart';

class HiveService {
  static const String schemeBoxName = 'schemes';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SchemeAdapter());

    // Open the box
    await Hive.openBox<Scheme>(schemeBoxName);

    // Seed data if empty
    final box = Hive.box<Scheme>(schemeBoxName);
    if (box.isEmpty) {
      await _seedSchemes(box);
    }
  }

  static Future<void> _seedSchemes(Box<Scheme> box) async {
    final schemes = [
      Scheme(
        id: 'SSY',
        name: 'Sukanya Samriddhi Yojana',
        description:
            'Small savings scheme for the girl child with tax benefits.\n\nNote: Account can be opened before girl child turns 10.',
        benefitAmount: 'High interest savings (long-term)',
        applicationUrl: 'https://www.indiapost.gov.in',
        rules: {'minAge': 0, 'maxAge': 10, 'gender': 'female'},
        requiredDocuments: [
          'Birth Certificate',
          'Guardian ID',
          'Address Proof',
        ],
      ),
      Scheme(
        id: 'PMMVY',
        name: 'Pradhan Mantri Matru Vandana Yojana',
        description:
            'Cash incentive for pregnant and lactating women for first living child.\n\nNote: Benefit released in instalments.',
        benefitAmount: '₹5000 (one-time)',
        applicationUrl: 'https://wcd.nic.in',
        rules: {
          'minAge': 19,
          'gender': 'female',
          'specialCategory': 'pregnant',
        },
        requiredDocuments: ['Aadhaar', 'MCP Card', 'Bank Account'],
      ),
      Scheme(
        id: 'IGNWPS',
        name: 'Indira Gandhi National Widow Pension Scheme',
        description:
            'Monthly pension for widows below poverty line.\n\nNote: States may add additional top-up.',
        benefitAmount: '₹300–₹500 (monthly)',
        applicationUrl: 'https://nsap.nic.in',
        rules: {
          'minAge': 40,
          'maxAge': 79,
          'gender': 'female',
          'specialCategory': 'widow',
        },
        requiredDocuments: [
          'Death Certificate',
          'Income Certificate',
          'Bank Account',
        ],
      ),
      Scheme(
        id: 'MSK',
        name: 'Mahila Shakti Kendra',
        description:
            'Community-based support services for rural women.\n\nNote: Implemented via state governments.',
        benefitAmount: 'Support services (ongoing)',
        applicationUrl: 'https://wcd.nic.in',
        rules: {'minAge': 18, 'gender': 'female'},
        requiredDocuments: ['ID Proof'],
      ),
      Scheme(
        id: 'BBBP',
        name: 'Beti Bachao Beti Padhao',
        description:
            'National initiative to promote education and welfare of the girl child.\n\nNote: No direct cash transfer.',
        benefitAmount: 'Indirect benefits (ongoing)',
        applicationUrl: 'https://wcd.nic.in',
        rules: {'maxAge': 18, 'gender': 'female'},
        requiredDocuments: ['Birth Certificate'],
      ),
      Scheme(
        id: 'WWH',
        name: 'Working Women Hostel Scheme',
        description:
            'Safe and affordable accommodation for working women.\n\nNote: Implemented through state agencies.',
        benefitAmount: 'Subsidized accommodation (monthly)',
        applicationUrl: 'https://wcd.nic.in',
        rules: {
          'minAge': 18,
          'gender': 'female',
          'occupation': 'working student',
        },
        requiredDocuments: ['Employment Proof', 'ID Proof'],
      ),
      Scheme(
        id: 'MH_LADKI_BAHIN',
        name: 'Mukhyamantri Majhi Ladki Bahin Yojana',
        description:
            'Monthly income support for eligible women in Maharashtra.\n\nNote: Flagship Maharashtra scheme.',
        benefitAmount: '₹1500 (monthly)',
        applicationUrl: 'https://ladkibahin.maharashtra.gov.in',
        rules: {
          'minAge': 21,
          'maxAge': 65,
          'gender': 'female',
          'maxIncome': 250000,
          'state': 'maharashtra',
        },
        requiredDocuments: [
          'Income Certificate',
          'Residence Proof',
          'Bank Account',
        ],
      ),
      Scheme(
        id: 'ANP_WOMEN',
        name: 'Annapurna Scheme',
        description:
            'Food security scheme for senior citizens not covered under pension.\n\nNote: Provided through PDS.',
        benefitAmount: '10kg food grains (monthly)',
        applicationUrl: 'https://nsap.nic.in',
        rules: {'minAge': 65, 'gender': 'female'},
        requiredDocuments: ['Age Proof'],
      ),
      Scheme(
        id: 'PM_KISAN',
        name: 'Pradhan Mantri Kisan Samman Nidhi',
        description:
            'Income support scheme providing ₹6000 per year to eligible landholding farmer families.\n\nNote: Excludes institutional landholders and certain high-income categories.',
        benefitAmount: '₹6000 (yearly (3 installments))',
        applicationUrl: 'https://pmkisan.gov.in',
        rules: {'occupation': 'farmer'},
        requiredDocuments: ['Land Ownership Record', 'Aadhaar', 'Bank Account'],
      ),
      Scheme(
        id: 'PMFBY',
        name: 'Pradhan Mantri Fasal Bima Yojana',
        description:
            'Crop insurance scheme protecting farmers against crop loss due to natural calamities.\n\nNote: Premium rates and coverage depend on crop and state notification.',
        benefitAmount: 'Crop loss compensation (per season)',
        applicationUrl: 'https://pmfby.gov.in',
        rules: {'occupation': 'farmer'},
        requiredDocuments: [
          'Land Record',
          'Sowing Certificate',
          'Bank Account',
          'Aadhaar',
        ],
      ),
      Scheme(
        id: 'KCC',
        name: 'Kisan Credit Card',
        description:
            'Credit facility for farmers to meet agricultural and allied activity expenses.\n\nNote: Loan limit and interest subsidy depend on bank and usage.',
        benefitAmount: 'Flexible crop loan (as required)',
        applicationUrl: 'https://www.pmkisan.gov.in/KCC.aspx',
        rules: {'minAge': 18, 'occupation': 'farmer'},
        requiredDocuments: ['Land Records', 'Bank KYC Documents', 'Aadhaar'],
      ),
      Scheme(
        id: 'SOIL_HEALTH_CARD',
        name: 'Soil Health Card Scheme',
        description:
            'Provides soil testing and nutrient recommendations to improve farm productivity.\n\nNote: Issued periodically by state agriculture departments.',
        benefitAmount: 'Free soil testing & recommendations (periodic)',
        applicationUrl: 'https://soilhealth.dac.gov.in',
        rules: {'occupation': 'farmer'},
        requiredDocuments: ['Land Details'],
      ),
      Scheme(
        id: 'E_NAM',
        name: 'National Agriculture Market (e-NAM)',
        description:
            'Online trading platform for agricultural produce across regulated markets.\n\nNote: Available only in e-NAM integrated mandis.',
        benefitAmount: 'Better price discovery (ongoing)',
        applicationUrl: 'https://www.enam.gov.in',
        rules: {'occupation': 'farmer'},
        requiredDocuments: ['Aadhaar', 'Bank Account', 'Farmer Registration'],
      ),
      Scheme(
        id: 'MH_LOAN_WAIVER',
        name: 'Mahatma Jyotirao Phule Shetkari Karjmukti Yojana',
        description:
            'Loan waiver scheme for eligible farmers in Maharashtra.\n\nNote: Eligibility conditions depend on loan type and cutoff dates.',
        benefitAmount: 'Up to ₹2 lakh (one-time)',
        applicationUrl: 'https://csmssy.maharashtra.gov.in',
        rules: {'occupation': 'farmer', 'state': 'maharashtra'},
        requiredDocuments: [
          'Loan Account Details',
          'Aadhaar',
          'Bank Documents',
        ],
      ),
      Scheme(
        id: 'SMAM',
        name: 'Sub-Mission on Agricultural Mechanization',
        description:
            'Financial assistance to farmers for purchasing modern agricultural machinery.\n\nNote: Subsidy rates vary by category and state.',
        benefitAmount: '40–60% subsidy on machinery (per purchase)',
        applicationUrl: 'https://agrimachinery.nic.in',
        rules: {'occupation': 'farmer'},
        requiredDocuments: [
          'Land Record',
          'Quotation for Machinery',
          'Bank Account',
        ],
      ),
      Scheme(
        id: 'PMKSY',
        name: 'Pradhan Mantri Krishi Sinchai Yojana',
        description:
            'Improves irrigation efficiency and water use in agriculture.\n\nNote: Implemented through state irrigation and agriculture departments.',
        benefitAmount: 'Irrigation support (project-based)',
        applicationUrl: 'https://pmksy.gov.in',
        rules: {'occupation': 'farmer'},
        requiredDocuments: ['Land Record', 'Bank Account'],
      ),
      Scheme(
        id: 'SC_PRE_MATRIC',
        name: 'Pre-Matric Scholarship for Scheduled Caste Students',
        description:
            'Financial assistance to SC students studying below Class 10.\n\nNote: Income ceiling and rates may vary slightly by state.',
        benefitAmount: '₹225–₹525 (monthly)',
        applicationUrl: 'https://scholarships.gov.in',
        rules: {'occupation': 'student', 'maxIncome': 250000, 'category': 'sc'},
        requiredDocuments: [
          'Caste Certificate',
          'Income Certificate',
          'School ID',
          'Bank Account',
          'Aadhaar',
        ],
      ),
      Scheme(
        id: 'SC_POST_MATRIC',
        name: 'Post-Matric Scholarship for Scheduled Caste Students',
        description:
            'Supports SC students pursuing education after Class 10.\n\nNote: Covers tuition fees and maintenance allowance.',
        benefitAmount: 'Tuition fees + maintenance allowance (yearly)',
        applicationUrl: 'https://scholarships.gov.in',
        rules: {'occupation': 'student', 'maxIncome': 250000, 'category': 'sc'},
        requiredDocuments: [
          'Caste Certificate',
          'Income Certificate',
          'College Admission Proof',
          'Bank Account',
          'Aadhaar',
        ],
      ),
      Scheme(
        id: 'ST_PRE_MATRIC',
        name: 'Pre-Matric Scholarship for Scheduled Tribe Students',
        description:
            'Scholarship for ST students studying below Class 10.\n\nNote: Administered through state governments.',
        benefitAmount: '₹225–₹525 (monthly)',
        applicationUrl: 'https://scholarships.gov.in',
        rules: {'occupation': 'student', 'maxIncome': 250000, 'category': 'st'},
        requiredDocuments: [
          'Tribe Certificate',
          'Income Certificate',
          'School ID',
          'Bank Account',
        ],
      ),
      Scheme(
        id: 'ST_POST_MATRIC',
        name: 'Post-Matric Scholarship for Scheduled Tribe Students',
        description:
            'Financial support for ST students in post-secondary education.\n\nNote: Rates differ by course level.',
        benefitAmount: 'Tuition fees + allowance (yearly)',
        applicationUrl: 'https://scholarships.gov.in',
        rules: {'occupation': 'student', 'maxIncome': 250000, 'category': 'st'},
        requiredDocuments: [
          'Tribe Certificate',
          'Income Certificate',
          'College ID',
          'Bank Account',
        ],
      ),
      Scheme(
        id: 'OBC_POST_MATRIC',
        name: 'Post-Matric Scholarship for OBC Students',
        description:
            'Scholarship for OBC students pursuing post-matric education.\n\nNote: Creamy layer exclusion applies.',
        benefitAmount: 'Tuition fees + allowance (yearly)',
        applicationUrl: 'https://scholarships.gov.in',
        rules: {
          'occupation': 'student',
          'maxIncome': 250000,
          'category': 'obc',
        },
        requiredDocuments: [
          'OBC Certificate',
          'Income Certificate',
          'College Admission Proof',
          'Bank Account',
        ],
      ),
      Scheme(
        id: 'NMMS',
        name: 'National Means-cum-Merit Scholarship',
        description:
            'Encourages meritorious students from economically weaker sections.\n\nNote: Selection based on state-level exam.',
        benefitAmount: '₹12000 (yearly)',
        applicationUrl: 'https://scholarships.gov.in',
        rules: {'occupation': 'student', 'maxIncome': 350000},
        requiredDocuments: [
          'School Certificate',
          'Income Certificate',
          'Merit Exam Proof',
          'Bank Account',
        ],
      ),
      Scheme(
        id: 'PRAGATI_GIRLS',
        name: 'Pragati Scholarship for Girls',
        description:
            'Scholarship for girls pursuing technical education.\n\nNote: Administered by AICTE.',
        benefitAmount: '₹50000 (yearly)',
        applicationUrl: 'https://www.aicte-india.org',
        rules: {
          'gender': 'female',
          'occupation': 'student',
          'maxIncome': 800000,
        },
        requiredDocuments: [
          'Admission Proof',
          'Income Certificate',
          'Bank Account',
          'Aadhaar',
        ],
      ),
      Scheme(
        id: 'SAKSHAM_PWD',
        name: 'Saksham Scholarship Scheme',
        description:
            'Financial support for students with disabilities in technical education.\n\nNote: Minimum 40% disability required.',
        benefitAmount: '₹50000 (yearly)',
        applicationUrl: 'https://www.aicte-india.org',
        rules: {
          'occupation': 'student',
          'maxIncome': 800000,
          'specialCategory': 'disability',
        },
        requiredDocuments: [
          'Disability Certificate',
          'Admission Proof',
          'Income Certificate',
          'Bank Account',
        ],
      ),
      Scheme(
        id: 'IGNDPS',
        name: 'Indira Gandhi National Disability Pension Scheme',
        description:
            'Monthly pension for persons with severe disabilities belonging to BPL households.\n\nNote: States may provide additional top-up amounts.',
        benefitAmount: '₹300–₹500 (monthly)',
        applicationUrl: 'https://nsap.nic.in',
        rules: {'minAge': 18, 'maxAge': 79, 'specialCategory': 'disability'},
        requiredDocuments: [
          'Disability Certificate (≥40%)',
          'Income Certificate',
          'Bank Account',
          'Aadhaar',
        ],
      ),
      Scheme(
        id: 'ADIP',
        name:
            'Assistance to Disabled Persons for Purchase of Aids and Appliances',
        description:
            'Provides aids and assistive devices to persons with disabilities to improve mobility and independence.\n\nNote: Income ceiling and device eligibility may vary.',
        benefitAmount: 'Free or subsidized assistive devices (as needed)',
        applicationUrl: 'https://depwd.gov.in',
        rules: {'maxIncome': 300000, 'specialCategory': 'disability'},
        requiredDocuments: [
          'Disability Certificate',
          'Income Certificate',
          'Medical Prescription',
          'Aadhaar',
        ],
      ),
      Scheme(
        id: 'DDRS',
        name: 'Deendayal Disabled Rehabilitation Scheme',
        description:
            'Supports NGOs providing rehabilitation, education, and vocational training to persons with disabilities.\n\nNote: Benefits are service-based, not direct cash transfers.',
        benefitAmount: 'Rehabilitation & skill services (ongoing)',
        applicationUrl: 'https://depwd.gov.in',
        rules: {'specialCategory': 'disability'},
        requiredDocuments: ['Disability Certificate', 'ID Proof'],
      ),
      Scheme(
        id: 'SMILE_TG',
        name:
            'SMILE – Support for Marginalized Individuals for Livelihood and Enterprise',
        description:
            'Provides rehabilitation, livelihood, and education support to transgender persons.\n\nNote: Implemented through state and NGO partners.',
        benefitAmount: 'Subsistence allowance + skill training (periodic)',
        applicationUrl: 'https://socialjustice.gov.in',
        rules: {'minAge': 18, 'specialCategory': 'transgender'},
        requiredDocuments: ['Transgender ID Card', 'Aadhaar', 'Bank Account'],
      ),
      Scheme(
        id: 'MH_DISABILITY_ASSIST',
        name: 'Assistance to Disabled Persons Scheme (Maharashtra)',
        description:
            'State-level assistance for persons with disabilities in Maharashtra.\n\nNote: Exact benefits vary by disability type and budget year.',
        benefitAmount: 'Financial assistance & devices (as per state norms)',
        applicationUrl: 'https://sjsa.maharashtra.gov.in',
        rules: {'state': 'maharashtra', 'specialCategory': 'disability'},
        requiredDocuments: [
          'Disability Certificate',
          'Domicile Certificate',
          'Income Certificate',
          'Bank Account',
        ],
      ),
      Scheme(
        id: 'NATIONAL_TRUST',
        name: 'National Trust Schemes (Niramaya and others)',
        description:
            'Provides health insurance and support services for persons with autism, cerebral palsy, intellectual disability, and multiple disabilities.\n\nNote: Different sub-schemes exist under National Trust.',
        benefitAmount: 'Health insurance up to ₹1 lakh (yearly)',
        applicationUrl: 'https://thenationaltrust.gov.in',
        rules: {'specialCategory': 'disability'},
        requiredDocuments: [
          'Disability Certificate',
          'National Trust Registration',
          'Aadhaar',
        ],
      ),
      Scheme(
        id: 'IGNOAPS',
        name: 'Indira Gandhi National Old Age Pension Scheme',
        description:
            'Monthly pension for senior citizens belonging to Below Poverty Line households.\n\nNote: States may provide additional pension over the central amount.',
        benefitAmount: '₹200–₹500 (monthly)',
        applicationUrl: 'https://nsap.nic.in',
        rules: {'minAge': 60, 'maxAge': 79},
        requiredDocuments: [
          'Age Proof',
          'Income Certificate',
          'Bank Account',
          'Aadhaar',
        ],
      ),
      Scheme(
        id: 'APY',
        name: 'Atal Pension Yojana',
        description:
            'Contributory pension scheme ensuring fixed income after 60 years of age.\n\nNote: Requires regular contributions until age 60.',
        benefitAmount: '₹1000–₹5000 (monthly (after 60))',
        applicationUrl: 'https://www.npscra.nsdl.co.in',
        rules: {'minAge': 18, 'maxAge': 40},
        requiredDocuments: ['Aadhaar', 'Bank Account'],
      ),
      Scheme(
        id: 'VPBY',
        name: 'Varishtha Pension Bima Yojana',
        description:
            'Guaranteed pension scheme for senior citizens operated by LIC.\n\nNote: Requires lump-sum investment; not income-tested.',
        benefitAmount:
            'Guaranteed pension based on investment (monthly / quarterly / yearly)',
        applicationUrl: 'https://licindia.in',
        rules: {'minAge': 60},
        requiredDocuments: ['Age Proof', 'ID Proof', 'Bank Account'],
      ),
      Scheme(
        id: 'ANP_ELDERLY',
        name: 'Annapurna Scheme',
        description:
            'Provides food security to elderly persons not covered under pension schemes.\n\nNote: Implemented through the Public Distribution System.',
        benefitAmount: '10 kg food grains (monthly)',
        applicationUrl: 'https://nsap.nic.in',
        rules: {'minAge': 65},
        requiredDocuments: ['Age Proof', 'Residence Proof'],
      ),
      Scheme(
        id: 'MH_OLD_AGE_PENSION',
        name: 'Maharashtra Old Age Pension Scheme',
        description:
            'State pension support for elderly residents of Maharashtra.\n\nNote: Benefit amount may vary based on additional state schemes.',
        benefitAmount: '₹600–₹1000 (monthly)',
        applicationUrl: 'https://aaplesarkar.maharashtra.gov.in',
        rules: {'minAge': 65, 'state': 'maharashtra'},
        requiredDocuments: [
          'Age Proof',
          'Domicile Certificate',
          'Income Certificate',
          'Bank Account',
        ],
      ),
      Scheme(
        id: 'PMJAY',
        name: 'Ayushman Bharat – Pradhan Mantri Jan Arogya Yojana',
        description:
            'Provides cashless health insurance coverage for secondary and tertiary care to eligible families.\n\nNote: Eligibility based on SECC database; no income cap explicitly defined.',
        benefitAmount: '₹5 lakh per family (yearly)',
        applicationUrl: 'https://pmjay.gov.in',
        rules: {},
        requiredDocuments: ['Aadhaar / ID Proof', 'Ration Card or SECC Data'],
      ),
      Scheme(
        id: 'PMAY_URBAN',
        name: 'Pradhan Mantri Awas Yojana – Urban',
        description:
            'Affordable housing scheme for economically weaker sections and low-income urban households.\n\nNote: Income limits and subsidy categories vary (EWS/LIG/MIG).',
        benefitAmount: 'Interest subsidy / housing assistance (one-time)',
        applicationUrl: 'https://pmaymis.gov.in',
        rules: {},
        requiredDocuments: [
          'Income Certificate',
          'Aadhaar',
          'Property Documents',
        ],
      ),
      Scheme(
        id: 'PMAY_GRAMIN',
        name: 'Pradhan Mantri Awas Yojana – Gramin',
        description:
            'Provides financial assistance for construction of pucca houses in rural areas.\n\nNote: Beneficiaries identified through SECC and Gram Sabha.',
        benefitAmount: '₹1.2–1.3 lakh (one-time)',
        applicationUrl: 'https://pmayg.nic.in',
        rules: {},
        requiredDocuments: ['SECC Verification', 'Aadhaar', 'Bank Account'],
      ),
      Scheme(
        id: 'PMKVY',
        name: 'Pradhan Mantri Kaushal Vikas Yojana',
        description:
            'Skill development initiative to enhance employability of youth.\n\nNote: Training aligned with National Skill Qualification Framework.',
        benefitAmount: 'Free training + certification (per course)',
        applicationUrl: 'https://pmkvyofficial.org',
        rules: {'minAge': 15},
        requiredDocuments: ['ID Proof', 'Aadhaar'],
      ),
      Scheme(
        id: 'NCS',
        name: 'National Career Service',
        description:
            'Employment portal offering job matching, career counselling, and skill information.\n\nNote: Registration is free and voluntary.',
        benefitAmount: 'Job matching & counselling (ongoing)',
        applicationUrl: 'https://www.ncs.gov.in',
        rules: {'minAge': 15},
        requiredDocuments: ['ID Proof', 'Educational Certificates'],
      ),
    ];

    await box.addAll(schemes);
  }

  static List<Scheme> getSchemes() {
    final box = Hive.box<Scheme>(schemeBoxName);
    return box.values.toList();
  }
}

class SchemeAdapter extends TypeAdapter<Scheme> {
  @override
  final int typeId = 0;

  @override
  Scheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Scheme(
      id: fields[0] as String,
      name: fields[1] as String,
      description: fields[2] as String,
      translatedNames: (fields[3] as Map).cast<String, String>(),
      translatedDescriptions: (fields[4] as Map).cast<String, String>(),
      rules: (fields[5] as Map).cast<String, dynamic>(),
      requiredDocuments: (fields[6] as List).cast<String>(),
      applicationUrl: fields[7] as String,
      benefitAmount: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Scheme obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.translatedNames)
      ..writeByte(4)
      ..write(obj.translatedDescriptions)
      ..writeByte(5)
      ..write(obj.rules)
      ..writeByte(6)
      ..write(obj.requiredDocuments)
      ..writeByte(7)
      ..write(obj.applicationUrl)
      ..writeByte(8)
      ..write(obj.benefitAmount);
  }
}
