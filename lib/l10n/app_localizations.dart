import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @q_age.
  ///
  /// In en, this message translates to:
  /// **'How old are you?'**
  String get q_age;

  /// No description provided for @q_gender.
  ///
  /// In en, this message translates to:
  /// **'What is your gender?'**
  String get q_gender;

  /// No description provided for @q_income.
  ///
  /// In en, this message translates to:
  /// **'What is your annual income?'**
  String get q_income;

  /// No description provided for @q_occupation.
  ///
  /// In en, this message translates to:
  /// **'What do you do?'**
  String get q_occupation;

  /// No description provided for @q_social_category.
  ///
  /// In en, this message translates to:
  /// **'What is your social category?'**
  String get q_social_category;

  /// No description provided for @q_special_category.
  ///
  /// In en, this message translates to:
  /// **'Do you belong to any special category?'**
  String get q_special_category;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Finding schemes for you...'**
  String get processing;

  /// No description provided for @age_0_18.
  ///
  /// In en, this message translates to:
  /// **'0-18 Years'**
  String get age_0_18;

  /// No description provided for @age_18_25.
  ///
  /// In en, this message translates to:
  /// **'18-25 Years'**
  String get age_18_25;

  /// No description provided for @age_26_40.
  ///
  /// In en, this message translates to:
  /// **'26-40 Years'**
  String get age_26_40;

  /// No description provided for @age_41_60.
  ///
  /// In en, this message translates to:
  /// **'41-60 Years'**
  String get age_41_60;

  /// No description provided for @age_60_plus.
  ///
  /// In en, this message translates to:
  /// **'60+ Years'**
  String get age_60_plus;

  /// No description provided for @gender_male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get gender_male;

  /// No description provided for @gender_female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get gender_female;

  /// No description provided for @gender_other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get gender_other;

  /// No description provided for @income_below_1l.
  ///
  /// In en, this message translates to:
  /// **'Below ₹1 Lakh'**
  String get income_below_1l;

  /// No description provided for @income_1l_2_5l.
  ///
  /// In en, this message translates to:
  /// **'₹1 Lakh - ₹2.5 Lakh'**
  String get income_1l_2_5l;

  /// No description provided for @income_2_5l_5l.
  ///
  /// In en, this message translates to:
  /// **'₹2.5 Lakh - ₹5 Lakh'**
  String get income_2_5l_5l;

  /// No description provided for @income_above_5l.
  ///
  /// In en, this message translates to:
  /// **'Above ₹5 Lakh'**
  String get income_above_5l;

  /// No description provided for @occ_farmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get occ_farmer;

  /// No description provided for @occ_student.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get occ_student;

  /// No description provided for @occ_worker.
  ///
  /// In en, this message translates to:
  /// **'Worker'**
  String get occ_worker;

  /// No description provided for @occ_artisan.
  ///
  /// In en, this message translates to:
  /// **'Artisan'**
  String get occ_artisan;

  /// No description provided for @occ_homemaker.
  ///
  /// In en, this message translates to:
  /// **'Homemaker'**
  String get occ_homemaker;

  /// No description provided for @occ_self_employed.
  ///
  /// In en, this message translates to:
  /// **'Self Employed'**
  String get occ_self_employed;

  /// No description provided for @state_maharashtra.
  ///
  /// In en, this message translates to:
  /// **'Maharashtra'**
  String get state_maharashtra;

  /// No description provided for @social_sc.
  ///
  /// In en, this message translates to:
  /// **'SC (Scheduled Caste)'**
  String get social_sc;

  /// No description provided for @social_st.
  ///
  /// In en, this message translates to:
  /// **'ST (Scheduled Tribe)'**
  String get social_st;

  /// No description provided for @social_obc.
  ///
  /// In en, this message translates to:
  /// **'OBC (Other Backward Class)'**
  String get social_obc;

  /// No description provided for @social_general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get social_general;

  /// No description provided for @special_disability.
  ///
  /// In en, this message translates to:
  /// **'Person with Disability'**
  String get special_disability;

  /// No description provided for @special_widow.
  ///
  /// In en, this message translates to:
  /// **'Widow'**
  String get special_widow;

  /// No description provided for @special_single_parent.
  ///
  /// In en, this message translates to:
  /// **'Single Parent'**
  String get special_single_parent;

  /// No description provided for @special_transgender.
  ///
  /// In en, this message translates to:
  /// **'Transgender'**
  String get special_transgender;

  /// No description provided for @q_location_type.
  ///
  /// In en, this message translates to:
  /// **'Is your area Rural or Urban?'**
  String get q_location_type;

  /// No description provided for @loc_rural.
  ///
  /// In en, this message translates to:
  /// **'Village (Rural) 🌳'**
  String get loc_rural;

  /// No description provided for @loc_urban.
  ///
  /// In en, this message translates to:
  /// **'City (Urban) 🏙️'**
  String get loc_urban;

  /// No description provided for @q_state.
  ///
  /// In en, this message translates to:
  /// **'Which State or Union Territory do you live in?'**
  String get q_state;

  /// No description provided for @state_andhra.
  ///
  /// In en, this message translates to:
  /// **'Andhra Pradesh'**
  String get state_andhra;

  /// No description provided for @state_arunachal.
  ///
  /// In en, this message translates to:
  /// **'Arunachal Pradesh'**
  String get state_arunachal;

  /// No description provided for @state_assam.
  ///
  /// In en, this message translates to:
  /// **'Assam'**
  String get state_assam;

  /// No description provided for @state_bihar.
  ///
  /// In en, this message translates to:
  /// **'Bihar'**
  String get state_bihar;

  /// No description provided for @state_chhattisgarh.
  ///
  /// In en, this message translates to:
  /// **'Chhattisgarh'**
  String get state_chhattisgarh;

  /// No description provided for @state_goa.
  ///
  /// In en, this message translates to:
  /// **'Goa'**
  String get state_goa;

  /// No description provided for @state_gujarat.
  ///
  /// In en, this message translates to:
  /// **'Gujarat'**
  String get state_gujarat;

  /// No description provided for @state_haryana.
  ///
  /// In en, this message translates to:
  /// **'Haryana'**
  String get state_haryana;

  /// No description provided for @state_himachal.
  ///
  /// In en, this message translates to:
  /// **'Himachal Pradesh'**
  String get state_himachal;

  /// No description provided for @state_jharkhand.
  ///
  /// In en, this message translates to:
  /// **'Jharkhand'**
  String get state_jharkhand;

  /// No description provided for @state_karnataka.
  ///
  /// In en, this message translates to:
  /// **'Karnataka'**
  String get state_karnataka;

  /// No description provided for @state_kerala.
  ///
  /// In en, this message translates to:
  /// **'Kerala'**
  String get state_kerala;

  /// No description provided for @state_mp.
  ///
  /// In en, this message translates to:
  /// **'Madhya Pradesh'**
  String get state_mp;

  /// No description provided for @state_manipur.
  ///
  /// In en, this message translates to:
  /// **'Manipur'**
  String get state_manipur;

  /// No description provided for @state_meghalaya.
  ///
  /// In en, this message translates to:
  /// **'Meghalaya'**
  String get state_meghalaya;

  /// No description provided for @state_mizoram.
  ///
  /// In en, this message translates to:
  /// **'Mizoram'**
  String get state_mizoram;

  /// No description provided for @state_nagaland.
  ///
  /// In en, this message translates to:
  /// **'Nagaland'**
  String get state_nagaland;

  /// No description provided for @state_odisha.
  ///
  /// In en, this message translates to:
  /// **'Odisha'**
  String get state_odisha;

  /// No description provided for @state_punjab.
  ///
  /// In en, this message translates to:
  /// **'Punjab'**
  String get state_punjab;

  /// No description provided for @state_rajasthan.
  ///
  /// In en, this message translates to:
  /// **'Rajasthan'**
  String get state_rajasthan;

  /// No description provided for @state_sikkim.
  ///
  /// In en, this message translates to:
  /// **'Sikkim'**
  String get state_sikkim;

  /// No description provided for @state_tn.
  ///
  /// In en, this message translates to:
  /// **'Tamil Nadu'**
  String get state_tn;

  /// No description provided for @state_telangana.
  ///
  /// In en, this message translates to:
  /// **'Telangana'**
  String get state_telangana;

  /// No description provided for @state_tripura.
  ///
  /// In en, this message translates to:
  /// **'Tripura'**
  String get state_tripura;

  /// No description provided for @state_up.
  ///
  /// In en, this message translates to:
  /// **'Uttar Pradesh'**
  String get state_up;

  /// No description provided for @state_uttarakhand.
  ///
  /// In en, this message translates to:
  /// **'Uttarakhand'**
  String get state_uttarakhand;

  /// No description provided for @state_wb.
  ///
  /// In en, this message translates to:
  /// **'West Bengal'**
  String get state_wb;

  /// No description provided for @ut_andaman.
  ///
  /// In en, this message translates to:
  /// **'Andaman & Nicobar'**
  String get ut_andaman;

  /// No description provided for @ut_chandigarh.
  ///
  /// In en, this message translates to:
  /// **'Chandigarh'**
  String get ut_chandigarh;

  /// No description provided for @ut_dadra.
  ///
  /// In en, this message translates to:
  /// **'Dadra & Nagar Haveli and Daman & Diu'**
  String get ut_dadra;

  /// No description provided for @ut_delhi.
  ///
  /// In en, this message translates to:
  /// **'Delhi'**
  String get ut_delhi;

  /// No description provided for @ut_jk.
  ///
  /// In en, this message translates to:
  /// **'Jammu & Kashmir'**
  String get ut_jk;

  /// No description provided for @ut_ladakh.
  ///
  /// In en, this message translates to:
  /// **'Ladakh'**
  String get ut_ladakh;

  /// No description provided for @ut_lakshadweep.
  ///
  /// In en, this message translates to:
  /// **'Lakshadweep'**
  String get ut_lakshadweep;

  /// No description provided for @ut_puducherry.
  ///
  /// In en, this message translates to:
  /// **'Puducherry'**
  String get ut_puducherry;

  /// No description provided for @q_land_ownership.
  ///
  /// In en, this message translates to:
  /// **'Do you own any agricultural land?'**
  String get q_land_ownership;

  /// No description provided for @land_none.
  ///
  /// In en, this message translates to:
  /// **'Landless 🚶'**
  String get land_none;

  /// No description provided for @land_small.
  ///
  /// In en, this message translates to:
  /// **'Small Land (Up to 5 Acres) 🌾'**
  String get land_small;

  /// No description provided for @land_large.
  ///
  /// In en, this message translates to:
  /// **'Large Land (More than 5 Acres) 🚜'**
  String get land_large;

  /// No description provided for @freq_daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get freq_daily;

  /// No description provided for @freq_monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get freq_monthly;

  /// No description provided for @freq_yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get freq_yearly;

  /// No description provided for @select_state_hint.
  ///
  /// In en, this message translates to:
  /// **'Select State / UT'**
  String get select_state_hint;

  /// No description provided for @find_my_schemes.
  ///
  /// In en, this message translates to:
  /// **'Find My Schemes'**
  String get find_my_schemes;

  /// No description provided for @error_missing_fields.
  ///
  /// In en, this message translates to:
  /// **'Please complete: {fields}'**
  String error_missing_fields(Object fields);

  /// No description provided for @field_age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get field_age;

  /// No description provided for @field_gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get field_gender;

  /// No description provided for @field_occupation.
  ///
  /// In en, this message translates to:
  /// **'Occupation'**
  String get field_occupation;

  /// No description provided for @field_location.
  ///
  /// In en, this message translates to:
  /// **'Location Type'**
  String get field_location;

  /// No description provided for @field_state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get field_state;

  /// No description provided for @field_land.
  ///
  /// In en, this message translates to:
  /// **'Land Ownership'**
  String get field_land;

  /// No description provided for @wishlist_title.
  ///
  /// In en, this message translates to:
  /// **'My Wishlist'**
  String get wishlist_title;

  /// No description provided for @btn_add_wishlist.
  ///
  /// In en, this message translates to:
  /// **'Save for Later'**
  String get btn_add_wishlist;

  /// No description provided for @btn_remove_wishlist.
  ///
  /// In en, this message translates to:
  /// **'Remove from Saved'**
  String get btn_remove_wishlist;

  /// No description provided for @btn_apply_now.
  ///
  /// In en, this message translates to:
  /// **'Apply Now'**
  String get btn_apply_now;

  /// No description provided for @view_schemes_title.
  ///
  /// In en, this message translates to:
  /// **'Recommended Schemes'**
  String get view_schemes_title;

  /// No description provided for @no_schemes_found.
  ///
  /// In en, this message translates to:
  /// **'No schemes found matching your profile.'**
  String get no_schemes_found;

  /// No description provided for @no_wishlist_items.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t saved any schemes yet.'**
  String get no_wishlist_items;

  /// No description provided for @required_documents.
  ///
  /// In en, this message translates to:
  /// **'Required Documents'**
  String get required_documents;

  /// No description provided for @doc_aadhaar.
  ///
  /// In en, this message translates to:
  /// **'Aadhaar Card'**
  String get doc_aadhaar;

  /// No description provided for @doc_pan.
  ///
  /// In en, this message translates to:
  /// **'PAN Card'**
  String get doc_pan;

  /// No description provided for @doc_land_record.
  ///
  /// In en, this message translates to:
  /// **'Land Record (7/12)'**
  String get doc_land_record;

  /// No description provided for @doc_income_proof.
  ///
  /// In en, this message translates to:
  /// **'Income Certificate'**
  String get doc_income_proof;

  /// No description provided for @doc_rural_address.
  ///
  /// In en, this message translates to:
  /// **'Rural Address Proof'**
  String get doc_rural_address;

  /// No description provided for @doc_bpl_card.
  ///
  /// In en, this message translates to:
  /// **'BPL Ration Card'**
  String get doc_bpl_card;

  /// No description provided for @doc_ration_card.
  ///
  /// In en, this message translates to:
  /// **'Ration Card'**
  String get doc_ration_card;

  /// No description provided for @doc_age_proof.
  ///
  /// In en, this message translates to:
  /// **'Age Proof'**
  String get doc_age_proof;

  /// No description provided for @doc_bank_account.
  ///
  /// In en, this message translates to:
  /// **'Bank Passbook'**
  String get doc_bank_account;

  /// No description provided for @doc_business_proof.
  ///
  /// In en, this message translates to:
  /// **'Business Registration Proof'**
  String get doc_business_proof;

  /// No description provided for @doc_vendor_id.
  ///
  /// In en, this message translates to:
  /// **'Street Vendor ID'**
  String get doc_vendor_id;

  /// No description provided for @doc_school_id.
  ///
  /// In en, this message translates to:
  /// **'School ID Card'**
  String get doc_school_id;

  /// No description provided for @doc_disability_cert.
  ///
  /// In en, this message translates to:
  /// **'Disability Certificate'**
  String get doc_disability_cert;

  /// No description provided for @doc_birth_cert.
  ///
  /// In en, this message translates to:
  /// **'Birth Certificate'**
  String get doc_birth_cert;

  /// No description provided for @doc_electricity_bill.
  ///
  /// In en, this message translates to:
  /// **'Electricity Bill'**
  String get doc_electricity_bill;

  /// No description provided for @doc_education_proof.
  ///
  /// In en, this message translates to:
  /// **'Education Certificate'**
  String get doc_education_proof;

  /// No description provided for @view_details.
  ///
  /// In en, this message translates to:
  /// **'View Details ->'**
  String get view_details;

  /// No description provided for @view_results.
  ///
  /// In en, this message translates to:
  /// **'View Results'**
  String get view_results;

  /// No description provided for @doc_yield_cert.
  ///
  /// In en, this message translates to:
  /// **'Yield Certificate'**
  String get doc_yield_cert;

  /// No description provided for @doc_caste_cert.
  ///
  /// In en, this message translates to:
  /// **'Caste Certificate'**
  String get doc_caste_cert;

  /// No description provided for @doc_residence_proof.
  ///
  /// In en, this message translates to:
  /// **'Residence Proof'**
  String get doc_residence_proof;

  /// No description provided for @doc_parents_aadhaar.
  ///
  /// In en, this message translates to:
  /// **'Parents Aadhaar'**
  String get doc_parents_aadhaar;

  /// No description provided for @doc_mother_aadhaar.
  ///
  /// In en, this message translates to:
  /// **'Mother Aadhaar'**
  String get doc_mother_aadhaar;

  /// No description provided for @doc_guardian_id.
  ///
  /// In en, this message translates to:
  /// **'Guardian ID'**
  String get doc_guardian_id;

  /// No description provided for @doc_child_birth_proof.
  ///
  /// In en, this message translates to:
  /// **'Child Birth Proof'**
  String get doc_child_birth_proof;

  /// No description provided for @doc_pregnancy_proof.
  ///
  /// In en, this message translates to:
  /// **'Pregnancy Proof'**
  String get doc_pregnancy_proof;

  /// No description provided for @doc_marriage_cert.
  ///
  /// In en, this message translates to:
  /// **'Marriage Certificate'**
  String get doc_marriage_cert;

  /// No description provided for @doc_death_cert.
  ///
  /// In en, this message translates to:
  /// **'Death Certificate'**
  String get doc_death_cert;

  /// No description provided for @doc_medical_cert.
  ///
  /// In en, this message translates to:
  /// **'Medical Certificate'**
  String get doc_medical_cert;

  /// No description provided for @doc_training_enrollment.
  ///
  /// In en, this message translates to:
  /// **'Training Enrollment'**
  String get doc_training_enrollment;

  /// No description provided for @doc_self_declaration.
  ///
  /// In en, this message translates to:
  /// **'Self Declaration'**
  String get doc_self_declaration;

  /// No description provided for @doc_bank_passbook.
  ///
  /// In en, this message translates to:
  /// **'Bank Passbook'**
  String get doc_bank_passbook;

  /// No description provided for @doc_voter_id.
  ///
  /// In en, this message translates to:
  /// **'Voter ID'**
  String get doc_voter_id;

  /// No description provided for @doc_driving_license.
  ///
  /// In en, this message translates to:
  /// **'Driving License'**
  String get doc_driving_license;

  /// No description provided for @doc_passport.
  ///
  /// In en, this message translates to:
  /// **'Passport'**
  String get doc_passport;

  /// No description provided for @doc_job_card.
  ///
  /// In en, this message translates to:
  /// **'MGNREGA Job Card'**
  String get doc_job_card;

  /// No description provided for @doc_shg_resolution.
  ///
  /// In en, this message translates to:
  /// **'SHG Resolution'**
  String get doc_shg_resolution;

  /// No description provided for @doc_project_report.
  ///
  /// In en, this message translates to:
  /// **'Project Report'**
  String get doc_project_report;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
