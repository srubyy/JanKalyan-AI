import 'package:hive_flutter/hive_flutter.dart';
import '../models/scheme.dart';

class HiveService {
  static const String schemeBoxName = 'schemes';
  static const String settingsBoxName = 'settings';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SchemeAdapter());

    // Open the box
    await Hive.openBox<Scheme>(schemeBoxName);
    await Hive.openBox(settingsBoxName);

    // Seed data if empty
    final box = Hive.box<Scheme>(schemeBoxName);
    if (box.isEmpty) {
      await _seedSchemes(box);
    }
  }

  static bool isFirstLaunch() {
    final box = Hive.box(settingsBoxName);
    return box.get('isFirstLaunch', defaultValue: true);
  }

  static Future<void> setFirstLaunchCompleted() async {
    final box = Hive.box(settingsBoxName);
    await box.put('isFirstLaunch', false);
  }

  static Future<void> _seedSchemes(Box<Scheme> box) async {
    final schemes = [
      Scheme(
        id: 'SSY',
        name: 'Sukanya Samriddhi Yojana',
        translatedNames: {
          'hi': 'सुकन्या समृद्धि योजना',
          'mr': 'सुकन्या समृद्धी योजना',
          'gu': 'સુકન્યા સમૃદ્ધિ યોજના',
        },
        description:
            'Small savings scheme for the girl child with tax benefits.\n\nNote: Account can be opened before girl child turns 10.',
        translatedDescriptions: {
          'hi':
              'बालिका के लिए कर लाभ वाली छोटी बचत योजना।\n\nनोट: खाता बालिका के 10 वर्ष की होने से पहले खोला जा सकता है।',
          'mr':
              'मुलींसाठी कर लाभांसह छोटी बचत योजना.\n\nटीप: मुलीचे वय १० वर्षे पूर्ण होण्यापूर्वी खाते उघडले जाऊ शकते.',
          'gu':
              'કર લાભો સાથે બાળકી માટે નાની બચત યોજના.\n\nનોંધ: બાળકી 10 વર્ષની થાય તે પહેલાં ખાતું ખોલાવી શકાય છે.',
        },
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
        translatedNames: {
          'hi': 'प्रधानमंत्री मातृ वंदना योजना',
          'mr': 'प्रधानमंत्री मातृ वंदना योजना',
          'gu': 'પ્રધાનમંત્રી માતૃ વંદના યોજના',
        },
        description:
            'Cash incentive for pregnant and lactating women for first living child.\n\nNote: Benefit released in instalments.',
        translatedDescriptions: {
          'hi':
              'पहले जीवित बच्चे के लिए गर्भवती और स्तनपान कराने वाली महिलाओं के लिए नकद प्रोत्साहन।\n\nनोट: लाभ किस्तों में जारी किया जाता है।',
          'mr':
              'पहिल्या जिवंत मुलासाठी गर्भवती आणि स्तनपान करणाऱ्या महिलांसाठी रोख प्रोत्साहन.\n\nटीप: लाभ हप्त्यांमध्ये दिला जातो.',
          'gu':
              'પ્રથમ જીવંત બાળક માટે સગર્ભા અને સ્તનપાન કરાવતી સ્ત્રીઓ માટે રોકડ પ્રોત્સાહન.\n\nનોંધ: લાભ હપ્તામાં આપવામાં આવે છે.',
        },
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
        translatedNames: {
          'hi': 'इंदिरा गांधी राष्ट्रीय विधवा पेंशन योजना',
          'mr': 'इंदिरा गांधी राष्ट्रीय विधवा निवृत्तीवेतन योजना',
          'gu': 'ઇન્દિરા ગાંધી રાષ્ટ્રીય વિધવા પેન્શન યોજના',
        },
        description:
            'Monthly pension for widows below poverty line.\n\nNote: States may add additional top-up.',
        translatedDescriptions: {
          'hi':
              'गरीबी रेखा से नीचे की विधवाओं के लिए मासिक पेंशन।\n\nनोट: राज्य अतिरिक्त राशि जोड़ सकते हैं।',
          'mr':
              'दारिद्र्य रेषेखालील विधवांना मासिक निवृत्तीवेतन.\n\nटीप: राज्ये अतिरिक्त रक्कम जोडू शकतात.',
          'gu':
              'ગરીબી રેખા નીચે જીવતી વિધવાઓ માટે માસિક પેન્શન.\n\nનોંધ: રાજ્યો વધારાની રકમ ઉમેરી શકે છે.',
        },
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
        translatedNames: {
          'hi': 'महिला शक्ति केंद्र',
          'mr': 'महिला शक्ती केंद्र',
          'gu': 'મહિલા શક્તિ કેન્દ્ર',
        },
        description:
            'Community-based support services for rural women.\n\nNote: Implemented via state governments.',
        translatedDescriptions: {
          'hi':
              'ग्रामीण महिलाओं के लिए समुदाय आधारित सहायता सेवाएं।\n\nनोट: राज्य सरकारों के माध्यम से लागू।',
          'mr':
              'ग्रामीण महिलांसाठी समाज आधारित मदत सेवा.\n\nटीप: राज्य सरकारांद्वारे राबविली जाते.',
          'gu':
              'ગ્રામીણ મહિલાઓ માટે સમુદાય આધારિત સહાય સેવાઓ.\n\nનોંધ: રાજ્ય સરકારો દ્વારા અમલમાં મૂકવામાં આવે છે.',
        },
        benefitAmount: 'Support services (ongoing)',
        applicationUrl: 'https://wcd.nic.in',
        rules: {'minAge': 18, 'gender': 'female'},
        requiredDocuments: ['ID Proof'],
      ),
      Scheme(
        id: 'BBBP',
        name: 'Beti Bachao Beti Padhao',
        translatedNames: {
          'hi': 'बेटी बचाओ बेटी पढ़ाओ',
          'mr': 'बेटी बचाओ बेटी पढाओ',
          'gu': 'બેટી બચાવો બેટી પઢાવો',
        },
        description:
            'National initiative to promote education and welfare of the girl child.\n\nNote: No direct cash transfer.',
        translatedDescriptions: {
          'hi':
              'बालिका की शिक्षा और कल्याण को बढ़ावा देने के लिए राष्ट्रीय पहल।\n\nनोट: कोई सीधा नकद हस्तांतरण नहीं।',
          'mr':
              'मुलींच्या शिक्षण आणि कल्याणाला चालना देण्यासाठी राष्ट्रीय उपक्रम.\n\nटीप: थेट रोख हस्तांतरण नाही.',
          'gu':
              'બાળકીના શિક્ષણ અને કલ્યાણને પ્રોત્સાહન આપવા માટે રાષ્ટ્રીય પહેલ.\n\nનોંધ: કોઈ સીધો રોકડ ટ્રાન્સફર નથી.',
        },
        benefitAmount: 'Indirect benefits (ongoing)',
        applicationUrl: 'https://wcd.nic.in',
        rules: {'maxAge': 18, 'gender': 'female'},
        requiredDocuments: ['Birth Certificate'],
      ),
      Scheme(
        id: 'WWH',
        name: 'Working Women Hostel Scheme',
        translatedNames: {
          'hi': 'कामकाजी महिला छात्रावास योजना',
          'mr': 'नोकरी करणाऱ्या महिलांसाठी वसतिगृह योजना',
          'gu': 'કામ કરતી મહિલાઓ માટે હોસ્ટેલ યોજના',
        },
        description:
            'Safe and affordable accommodation for working women.\n\nNote: Implemented through state agencies.',
        translatedDescriptions: {
          'hi':
              'कामकाजी महिलाओं के लिए सुरक्षित और किफायती आवास।\n\nनोट: राज्य एजेंसियों के माध्यम से लागू।',
          'mr':
              'नोकरी करणाऱ्या महिलांसाठी सुरक्षित आणि परवडणारी राहण्याची सोय.\n\nटीप: राज्य संस्थांद्वारे राबविली जाते.',
          'gu':
              'કામ કરતી મહિલાઓ માટે સુરક્ષિત અને પોસાય તેવું રહેઠાણ.\n\nનોંધ: રાજ્ય એજન્સીઓ દ્વારા અમલમાં મૂકાયેલ.',
        },
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
        translatedNames: {
          'hi': 'मुख्यमंत्री माझी लाडकी बहिन योजना',
          'mr': 'मुख्यमंत्री माझी लाडकी बहीण योजना',
          'gu': 'મુખ્યમંત્રી માઝી લાડકી બહેન યોજના',
        },
        description:
            'Monthly income support for eligible women in Maharashtra.\n\nNote: Flagship Maharashtra scheme.',
        translatedDescriptions: {
          'hi':
              'महाराष्ट्र में पात्र महिलाओं के लिए मासिक आय सहायता।\n\nनोट: महाराष्ट्र की प्रमुख योजना।',
          'mr':
              'महाराष्ट्रातील पात्र महिलांसाठी मासिक उत्पन्न मदत.\n\nटीप: महाराष्ट्राची प्रमुख योजना.',
          'gu':
              'મહારાષ્ટ્રમાં પાત્ર મહિલાઓ માટે માસિક આવક સહાય.\n\nનોંધ: મહારાષ્ટ્રની મુખ્ય યોજના.',
        },
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
        translatedNames: {
          'hi': 'प्रधानमंत्री किसान सम्मान निधि',
          'mr': 'प्रधानमंत्री किसान सन्मान निधी',
          'gu': 'પ્રધાનમંત્રી કિસાન સન્માન નિધિ',
        },
        description:
            'Income support scheme providing ₹6000 per year to eligible landholding farmer families.\n\nNote: Excludes institutional landholders and certain high-income categories.',
        translatedDescriptions: {
          'hi':
              'पात्र भूमिधारक किसान परिवारों को प्रति वर्ष ₹6000 प्रदान करने वाली आय सहायता योजना।\n\nनोट: संस्थागत भूमिधारकों और कुछ उच्च आय श्रेणियों को शामिल नहीं करता है।',
          'mr':
              'पात्र जमीनदार शेतकरी कुटुंबांना वर्षाला ₹६००० देणारी उत्पन्न साहाय्य योजना.\n\nटीप: संस्थात्मक जमीनदार आणि काही उच्च-उत्पन्न श्रेणी वगळतात.',
          'gu':
              'પાત્ર જમીન ધરાવતા ખેડૂત પરિવારોને વર્ષે ₹6000 પ્રદાન કરતી આવક સહાય યોજના.\n\nનોંધ: સંસ્થાકીય જમીનધારકો અને અમુક ઉચ્ચ આવક વર્ગોને બાકાત રાખે છે.',
        },
        benefitAmount: '₹6000 (yearly (3 installments))',
        applicationUrl: 'https://pmkisan.gov.in',
        rules: {'occupation': 'farmer'},
        requiredDocuments: ['Land Ownership Record', 'Aadhaar', 'Bank Account'],
      ),
      Scheme(
        id: 'PMFBY',
        name: 'Pradhan Mantri Fasal Bima Yojana',
        translatedNames: {
          'hi': 'प्रधानमंत्री फसल बीमा योजना',
          'mr': 'प्रधानमंत्री पीक विमा योजना',
          'gu': 'પ્રધાનમંત્રી પાક વીમા યોજના',
        },
        description:
            'Crop insurance scheme protecting farmers against crop loss due to natural calamities.\n\nNote: Premium rates and coverage depend on crop and state notification.',
        translatedDescriptions: {
          'hi':
              'प्राकृतिक आपदाओं के कारण फसल क्षति से किसानों की सुरक्षा करने वाली फसल बीमा योजना।\n\nनोट: प्रीमियम दरें और कवरेज फसल और राज्य अधिसूचना पर निर्भर करती हैं।',
          'mr':
              'नैसर्गिक आपत्तींमुळे पिकाच्या नुकसानापासून शेतकऱ्यांचे संरक्षण करणारी पीक विमा योजना.\n\nटीप: प्रीमियम दर आणि संरक्षण पीक आणि राज्य अधिसूचनेवर अवलंबून असते.',
          'gu':
              'કુદરતી આફતોને કારણે પાકના નુકસાન સામે ખેડૂતોને રક્ષણ આપતી પાક વીમા યોજના.\n\nનોંધ: પ્રીમિયમ દરો અને કવરેજ પાક અને રાજ્ય સૂચના પર આધારિત છે.',
        },
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
        translatedNames: {
          'hi': 'किसान क्रेडिट कार्ड',
          'mr': 'किसान क्रेडिट कार्ड',
          'gu': 'કિસાન ક્રેડિટ કાર્ડ',
        },
        description:
            'Credit facility for farmers to meet agricultural and allied activity expenses.\n\nNote: Loan limit and interest subsidy depend on bank and usage.',
        translatedDescriptions: {
          'hi':
              'किसानों को कृषि और संबद्ध गतिविधियों के खर्चों को पूरा करने के लिए क्रेडिट सुविधा।\n\nनोट: ऋण सीमा और ब्याज सब्सिडी बैंक और उपयोग पर निर्भर करती है।',
          'mr':
              'शेतकऱ्यांना कृषी आणि संलग्न क्रियाकलापांचा खर्च पूर्ण करण्यासाठी पत सुविधा.\n\nटीप: कर्ज मर्यादा आणि व्याज अनुदान बँक आणि वापरावर अवलंबून असते.',
          'gu':
              'ખેડૂતોને કૃષિ અને સંલગ્ન પ્રવૃત્તિઓના ખર્ચને પહોંચી વળવા માટે ક્રેડિટ સુવિધા.\n\nનોંધ: લોન મર્યાદા અને વ્યાજ સબસિડી બેંક અને વપરાશ પર આધારિત છે.',
        },
        benefitAmount: 'Flexible crop loan (as required)',
        applicationUrl: 'https://www.pmkisan.gov.in/KCC.aspx',
        rules: {'minAge': 18, 'occupation': 'farmer'},
        requiredDocuments: ['Land Records', 'Bank KYC Documents', 'Aadhaar'],
      ),
      Scheme(
        id: 'SOIL_HEALTH_CARD',
        name: 'Soil Health Card Scheme',
        translatedNames: {
          'hi': 'मृदा स्वास्थ्य कार्ड योजना',
          'mr': 'मृदा आरोग्य कार्ड योजना',
          'gu': 'જમીન આરોગ્ય કાર્ડ યોજના',
        },
        description:
            'Provides soil testing and nutrient recommendations to improve farm productivity.\n\nNote: Issued periodically by state agriculture departments.',
        translatedDescriptions: {
          'hi':
              'कृषि उत्पादकता में सुधार के लिए मृदा परीक्षण और पोषक तत्वों की सिफारिशें प्रदान करता है।\n\nनोट: राज्य कृषि विभागों द्वारा समय-समय पर जारी किया जाता है।',
          'mr':
              'शेत उत्पादकता सुधारण्यासाठी मृदा परीक्षण आणि पोषक शिफारसी प्रदान करते.\n\nटीप: राज्य कृषी विभागांद्वारे वेळोवेळी जारी केले जाते.',
          'gu':
              'ખેત ઉત્પાદકતા સુધારવા માટે જમીન પરીક્ષણ અને પોષક તત્ત્વોની ભલામણો પ્રદાન કરે છે.\n\nનોંધ: રાજ્ય કૃષિ વિભાગો દ્વારા સમયાંતરે જારી કરવામાં આવે છે.',
        },
        benefitAmount: 'Free soil testing & recommendations (periodic)',
        applicationUrl: 'https://soilhealth.dac.gov.in',
        rules: {'occupation': 'farmer'},
        requiredDocuments: ['Land Details'],
      ),
      Scheme(
        id: 'E_NAM',
        name: 'National Agriculture Market (e-NAM)',
        translatedNames: {
          'hi': 'राष्ट्रीय कृषि बाजार (e-NAM)',
          'mr': 'राष्ट्रीय कृषी बाजार (e-NAM)',
          'gu': 'રાષ્ટ્રીય કૃષિ બજાર (e-NAM)',
        },
        description:
            'Online trading platform for agricultural produce across regulated markets.\n\nNote: Available only in e-NAM integrated mandis.',
        translatedDescriptions: {
          'hi':
              'विनियमित बाजारों में कृषि उपज के लिए ऑनलाइन ट्रेडिंग प्लेटफॉर्म।\n\nनोट: केवल e-NAM एकीकृत मंडियों में उपलब्ध।',
          'mr':
              'विनियमित बाजारांमध्ये कृषी उत्पादनासाठी ऑनलाइन ट्रेडिंग प्लॅटफॉर्म.\n\nटीप: फक्त e-NAM एकत्रीकृत मंडईत उपलब्ध.',
          'gu':
              'નિયંત્રિત બજારોમાં કૃષિ પેદાશો માટે ઓનલાઇન ટ્રેડિંગ પ્લેટફોર્મ.\n\nનોંધ: માત્ર e-NAM સંકલિત મંડીઓમાં ઉપલબ્ધ.',
        },
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
        translatedNames: {
          'hi': 'आयुष्मान भारत - प्रधानमंत्री जन आरोग्य योजना',
          'mr': 'आयुष्मान भारत - प्रधानमंत्री जन आरोग्य योजना',
          'gu': 'આયુષ્માન ભારત - પ્રધાનમંત્રી જન આરોગ્ય યોજના',
        },
        description:
            'Provides cashless health insurance coverage for secondary and tertiary care to eligible families.\n\nNote: Eligibility based on SECC database; no income cap explicitly defined.',
        translatedDescriptions: {
          'hi':
              'पात्र परिवारों को द्वितीयक और तृतीयक देखभाल के लिए कैशलेस स्वास्थ्य बीमा कवरेज प्रदान करता है।\n\nनोट: पात्रता एसईसीसी डेटाबेस पर आधारित; कोई आय सीमा स्पष्ट रूप से परिभाषित नहीं है।',
          'mr':
              'पात्र कुटुंबांना दुय्यम आणि तृतीयक सेवेसाठी कॅशलेस आरोग्य विमा संरक्षण प्रदान करते.\n\nटीप: पात्रता एसईसीसी डेटाबेसवर आधारित; कोणतीही उत्पन्न मर्यादा स्पष्टपणे परिभाषित केलेली नाही.',
          'gu':
              'પાત્ર પરિવારોને ગૌણ અને તૃતીય સંભાળ માટે કેશલેસ આરોગ્ય વીમા કવરેજ પૂરું પાડે છે.\n\nનોંધ: પાત્રતા SECC ડેટાબેઝ પર આધારિત છે; કોઈ આવક મર્યાદા સ્પષ્ટપણે વ્યાખ્યાયિત નથી.',
        },
        benefitAmount: '₹5 lakh per family (yearly)',
        applicationUrl: 'https://pmjay.gov.in',
        rules: {},
        requiredDocuments: ['Aadhaar / ID Proof', 'Ration Card or SECC Data'],
      ),
      Scheme(
        id: 'PMAY_URBAN',
        name: 'Pradhan Mantri Awas Yojana – Urban',
        translatedNames: {
          'hi': 'प्रधानमंत्री आवास योजना - शहरी',
          'mr': 'प्रधानमंत्री आवास योजना - शहरी',
          'gu': 'પ્રધાનમંત્રી આવાસ યોજના - શહેરી',
        },
        description:
            'Affordable housing scheme for economically weaker sections and low-income urban households.\n\nNote: Income limits and subsidy categories vary (EWS/LIG/MIG).',
        translatedDescriptions: {
          'hi':
              'आर्थिक रूप से कमजोर वर्गों और कम आय वाले शहरी परिवारों के लिए किफायती आवास योजना।\n\nनोट: आय सीमा और सब्सिडी श्रेणियां भिन्न होती हैं (EWS/LIG/MIG)।',
          'mr':
              'आर्थिकदृष्ट्या दुर्बल घटकांसाठी आणि कमी उत्पन्न असलेल्या शहरी कुटुंबांसाठी परवडणारी घरकुल योजना.\n\nटीप: उत्पन्न मर्यादा आणि अनुदान श्रेणी बदलू शकतात (EWS/LIG/MIG).',
          'gu':
              'આર્થિક રીતે નબળા વર્ગો અને ઓછી આવક ધરાવતા શહેરી પરિવારો માટે પોસાય તેવી આવાસ યોજના.\n\nનોંધ: આવક મર્યાદા અને સબસિડી શ્રેણીઓ બદલાય છે (EWS/LIG/MIG).',
        },
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
        translatedNames: {
          'hi': 'प्रधानमंत्री आवास योजना - ग्रामीण',
          'mr': 'प्रधानमंत्री आवास योजना - ग्रामीण',
          'gu': 'પ્રધાનમંત્રી આવાસ યોજના - ગ્રામીણ',
        },
        description:
            'Provides financial assistance for construction of pucca houses in rural areas.\n\nNote: Beneficiaries identified through SECC and Gram Sabha.',
        translatedDescriptions: {
          'hi':
              'ग्रामीण क्षेत्रों में पक्के घरों के निर्माण के लिए वित्तीय सहायता प्रदान करता है।\n\nनोट: लाभार्थियों की पहचान एसईसीसी और ग्राम सभा के माध्यम से की जाती है।',
          'mr':
              'ग्रामीण भागात पक्की घरे बांधण्यासाठी आर्थिक मदत दिली जाते.\n\nटीप: लाभार्थी एसईसीसी आणि ग्रामसभेद्वारे ओळखले जातात.',
          'gu':
              'ગ્રામીણ વિસ્તારોમાં પાકા મકાનોના નિર્માણ માટે નાણાકીય સહાય પૂરી પાડે છે.\n\nનોંધ: SECC અને ગ્રામસભા દ્વારા લાભાર્થીઓની ઓળખ કરવામાં આવે છે.',
        },
        benefitAmount: '₹1.2–1.3 lakh (one-time)',
        applicationUrl: 'https://pmayg.nic.in',
        rules: {},
        requiredDocuments: ['SECC Verification', 'Aadhaar', 'Bank Account'],
      ),
      Scheme(
        id: 'PMKVY',
        name: 'Pradhan Mantri Kaushal Vikas Yojana',
        translatedNames: {
          'hi': 'प्रधानमंत्री कौशल विकास योजना',
          'mr': 'प्रधानमंत्री कौशल विकास योजना',
          'gu': 'પ્રધાનમંત્રી કૌશલ વિકાસ યોજના',
        },
        description:
            'Skill development initiative to enhance employability of youth.\n\nNote: Training aligned with National Skill Qualification Framework.',
        translatedDescriptions: {
          'hi':
              'युवाओं की रोजगार क्षमता बढ़ाने के लिए कौशल विकास पहल।\n\nनोट: प्रशिक्षण राष्ट्रीय कौशल योग्यता ढांचे के अनुरूप है।',
          'mr':
              'तरुणांची रोजगारक्षमता वाढवण्यासाठी कौशल्य विकास उपक्रम.\n\nटीप: प्रशिक्षण राष्ट्रीय कौशल्य अर्हता फ्रेमवर्कशी संरेखित आहे.',
          'gu':
              'યુવાનોની રોજગાર યોગ્યતા વધારવા માટે કૌશલ્ય વિકાસ પહેલ.\n\nનોંધ: તાલીમ રાષ્ટ્રીય કૌશલ્ય લાયકાત ફ્રેમવર્ક સાથે સંલગ્ન છે.',
        },
        benefitAmount: 'Free training + certification (per course)',
        applicationUrl: 'https://pmkvyofficial.org',
        rules: {'minAge': 15},
        requiredDocuments: ['ID Proof', 'Aadhaar'],
      ),
      Scheme(
        id: 'NCS',
        name: 'National Career Service',
        translatedNames: {
          'hi': 'नेशनल करियर सर्विस',
          'mr': 'नॅशनल करिअर सर्व्हिस',
          'gu': 'નેશનલ કેરિયર સર્વિસ',
        },
        description:
            'Employment portal offering job matching, career counselling, and skill information.\n\nNote: Registration is free and voluntary.',
        translatedDescriptions: {
          'hi':
              'नौकरी मिलान, करियर परामर्श और कौशल जानकारी प्रदान करने वाला रोजगार पोर्टल।\n\nनोट: पंजीकरण नि:शुल्क और स्वैच्छिक है।',
          'mr':
              'नोकरी जुळवणी, करिअर समुपदेशन आणि कौशल्य माहिती देणारे रोजगार पोर्टल.\n\nटीप: नोंदणी विनामूल्य आणि ऐच्छिक आहे.',
          'gu':
              'નોકરી મેચિંગ, કારકિર્દી કાઉન્સેલિંગ અને કૌશલ્ય માહિતી પ્રદાન કરતું રોજગાર પોર્ટલ.\n\nનોંધ: નોંધણી મફત અને સ્વૈચ્છિક છે.',
        },
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
