import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_mr.dart';

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
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('mr')
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
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'gu', 'hi', 'mr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'gu': return AppLocalizationsGu();
    case 'hi': return AppLocalizationsHi();
    case 'mr': return AppLocalizationsMr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
