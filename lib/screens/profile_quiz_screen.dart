// lib/screens/profile_quiz_screen.dart

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/user_profile.dart';
import '../data/hive_service.dart';
import '../logic/eligibility_engine.dart';
import 'dashboard_screen.dart';
import '../widgets/auto_translated_text.dart';

class ProfileQuizScreen extends StatefulWidget {
  const ProfileQuizScreen({super.key});

  @override
  State<ProfileQuizScreen> createState() => _ProfileQuizScreenState();
}

class _ProfileQuizScreenState extends State<ProfileQuizScreen> {
  String? _ageGroup;
  String? _gender;

  String? _occupation;
  String? _socialCategory;
  String? _specialCategory;
  String? _locationType;
  String? _selectedState;
  String? _landOwnership;
  String _incomeFrequency = 'monthly';
  double _incomeAmount = 10000;

  void _submitProfile() {
    final l10n = AppLocalizations.of(context)!;
    List<String> missingFields = [];
    if (_ageGroup == null) missingFields.add(l10n.field_age);
    if (_gender == null) missingFields.add(l10n.field_gender);
    if (_occupation == null) missingFields.add(l10n.field_occupation);
    if (_locationType == null) missingFields.add(l10n.field_location);
    if (_selectedState == null) missingFields.add(l10n.field_state);
    if (_landOwnership == null) missingFields.add(l10n.field_land);

    if (missingFields.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.error_missing_fields(missingFields.join(", "))),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    int age;
    if (_ageGroup == '0-18') {
      age = 18;
    } else if (_ageGroup == '18-25') {
      age = 22;
    } else if (_ageGroup == '26-40') {
      age = 33;
    } else if (_ageGroup == '41-60') {
      age = 50;
    } else {
      age = 65;
    }

    double yearlyIncome = _incomeAmount;
    if (_incomeFrequency == 'daily') {
      yearlyIncome = _incomeAmount * 365;
    } else if (_incomeFrequency == 'monthly') {
      yearlyIncome = _incomeAmount * 12;
    }

    final profile = UserProfile(
      age: age,
      gender: _gender!,
      income: yearlyIncome,
      occupation: _occupation!,
      state: _selectedState!,
      socialCategory: _socialCategory,
      specialCategory: _specialCategory,
    );

    // Filter schemes locally
    final allSchemes = HiveService.getSchemes();
    final eligibleSchemes = allSchemes.where((scheme) {
      final result = EligibilityEngine.evaluate(profile, scheme);
      return result.status == EligibilityStatus.eligible ||
          result.status == EligibilityStatus.nearlyEligible;
    }).toList();

    // Mark onboarding as completed
    HiveService.setFirstLaunchCompleted();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DashboardScreen(
          schemes: eligibleSchemes,
          userProfile: profile, // Pass profile for details
        ),
      ),
    );
  }

  void _updateIncomeFrequency(String frequency) {
    setState(() {
      _incomeFrequency = frequency;
      double maxLimit = 1000000;
      if (frequency == 'daily') {
        maxLimit = 5000;
      } else if (frequency == 'monthly') {
        maxLimit = 100000;
      }

      if (_incomeAmount > maxLimit) {
        _incomeAmount = maxLimit;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStateSection(l10n),
                    const SizedBox(height: 32),
                    _buildGenderSection(l10n),
                    const SizedBox(height: 32),
                    _buildAgeSection(l10n),
                    const SizedBox(height: 32),
                    _buildLocationTypeSection(l10n),
                    const SizedBox(height: 32),
                    _buildOccupationSection(l10n),
                    const SizedBox(height: 32),
                    _buildIncomeSection(l10n),
                    const SizedBox(height: 32),
                    _buildLandOwnershipSection(l10n),
                    const SizedBox(height: 32),
                    _buildSocialCategorySection(l10n),
                    const SizedBox(height: 32),
                    _buildSpecialCategorySection(l10n),
                    const SizedBox(height: 32),
                    _buildSubmitButton(l10n),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Row(
        children: [
          AutoTranslatedText(
            'Smart Profile Builder',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslatedText(
          l10n.q_gender,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _BigIconCard(
                icon: Icons.male,
                label: l10n.gender_male,
                color: Colors.blue,
                isSelected: _gender == 'male',
                onTap: () => setState(() => _gender = 'male'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _BigIconCard(
                icon: Icons.female,
                label: l10n.gender_female,
                color: Colors.pink,
                isSelected: _gender == 'female',
                onTap: () => setState(() => _gender = 'female'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOccupationSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslatedText(
          l10n.q_occupation,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SmallIconCard(
              icon: Icons.agriculture,
              label: l10n.occ_farmer,
              isSelected: _occupation == 'farmer',
              onTap: () => setState(() => _occupation = 'farmer'),
            ),
            _SmallIconCard(
              icon: Icons.school,
              label: l10n.occ_student,
              isSelected: _occupation == 'student',
              onTap: () => setState(() => _occupation = 'student'),
            ),
            _SmallIconCard(
              icon: Icons.construction,
              label: l10n.occ_worker,
              isSelected: _occupation == 'worker',
              onTap: () => setState(() => _occupation = 'worker'),
            ),
            _SmallIconCard(
              icon: Icons.handyman,
              label: l10n.occ_artisan,
              isSelected: _occupation == 'artisan',
              onTap: () => setState(() => _occupation = 'artisan'),
            ),
            _SmallIconCard(
              icon: Icons.home,
              label: l10n.occ_homemaker,
              isSelected: _occupation == 'homemaker',
              onTap: () => setState(() => _occupation = 'homemaker'),
            ),
            _SmallIconCard(
              icon: Icons.business,
              label: l10n.occ_self_employed,
              isSelected: _occupation == 'self_employed',
              onTap: () => setState(() => _occupation = 'self_employed'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIncomeSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslatedText(
          l10n.q_income,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!, width: 1.5),
          ),
          child: Row(
            children: [
              _FrequencyButton(
                label: l10n.freq_daily,
                isSelected: _incomeFrequency == 'daily',
                onTap: () => _updateIncomeFrequency('daily'),
                isFirst: true,
              ),
              _FrequencyButton(
                label: l10n.freq_monthly,
                isSelected: _incomeFrequency == 'monthly',
                onTap: () => _updateIncomeFrequency('monthly'),
              ),
              _FrequencyButton(
                label: l10n.freq_yearly,
                isSelected: _incomeFrequency == 'yearly',
                onTap: () => _updateIncomeFrequency('yearly'),
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: Colors.purple,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: Colors.purple,
            overlayColor: Colors.purple.withValues(alpha: 0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
          ),
          child: Slider(
            value: _incomeAmount,
            min: 0,
            max: _incomeFrequency == 'daily'
                ? 5000
                : _incomeFrequency == 'monthly'
                ? 100000
                : 1000000,
            divisions: 100,
            onChanged: (value) => setState(() => _incomeAmount = value),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purple, width: 2),
          ),
          child: Row(
            children: [
              const Text(
                '₹ ',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              Text(
                _incomeAmount.toStringAsFixed(0),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAgeSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslatedText(
          l10n.q_age,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SmallIconCard(
              icon: Icons.child_care,
              label: l10n.age_0_18,
              isSelected: _ageGroup == '0-18',
              onTap: () => setState(() => _ageGroup = '0-18'),
            ),
            _SmallIconCard(
              icon: Icons.school,
              label: l10n.age_18_25,
              isSelected: _ageGroup == '18-25',
              onTap: () => setState(() => _ageGroup = '18-25'),
            ),
            _SmallIconCard(
              icon: Icons.work,
              label: l10n.age_26_40,
              isSelected: _ageGroup == '26-40',
              onTap: () => setState(() => _ageGroup = '26-40'),
            ),
            _SmallIconCard(
              icon: Icons.business_center,
              label: l10n.age_41_60,
              isSelected: _ageGroup == '41-60',
              onTap: () => setState(() => _ageGroup = '41-60'),
            ),
            _SmallIconCard(
              icon: Icons.elderly,
              label: l10n.age_60_plus,
              isSelected: _ageGroup == '60+',
              onTap: () => setState(() => _ageGroup = '60+'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialCategorySection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AutoTranslatedText(
              l10n.q_social_category,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            AutoTranslatedText(
              '(${l10n.skip})',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SmallIconCard(
              icon: Icons.people,
              label: l10n.social_sc,
              isSelected: _socialCategory == 'SC',
              onTap: () => setState(() => _socialCategory = 'SC'),
            ),
            _SmallIconCard(
              icon: Icons.people_outline,
              label: l10n.social_st,
              isSelected: _socialCategory == 'ST',
              onTap: () => setState(() => _socialCategory = 'ST'),
            ),
            _SmallIconCard(
              icon: Icons.groups,
              label: l10n.social_obc,
              isSelected: _socialCategory == 'OBC',
              onTap: () => setState(() => _socialCategory = 'OBC'),
            ),
            _SmallIconCard(
              icon: Icons.person,
              label: l10n.social_general,
              isSelected: _socialCategory == 'General',
              onTap: () => setState(() => _socialCategory = 'General'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpecialCategorySection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: AutoTranslatedText(
                l10n.q_special_category,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 8),
            AutoTranslatedText(
              '(${l10n.skip})',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SmallIconCard(
              icon: Icons.accessible,
              label: l10n.special_disability,
              isSelected: _specialCategory == 'disability',
              onTap: () => setState(() => _specialCategory = 'disability'),
            ),
            _SmallIconCard(
              icon: Icons.woman,
              label: l10n.special_widow,
              isSelected: _specialCategory == 'widow',
              onTap: () => setState(() => _specialCategory = 'widow'),
            ),
            _SmallIconCard(
              icon: Icons.family_restroom,
              label: l10n.special_single_parent,
              isSelected: _specialCategory == 'single_parent',
              onTap: () => setState(() => _specialCategory = 'single_parent'),
            ),
            _SmallIconCard(
              icon: Icons.transgender,
              label: l10n.special_transgender,
              isSelected: _specialCategory == 'transgender',
              onTap: () => setState(() => _specialCategory = 'transgender'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationTypeSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslatedText(
          l10n.q_location_type,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _BigIconCard(
                icon: Icons.nature_people,
                label: l10n.loc_rural,
                color: Colors.green,
                isSelected: _locationType == 'rural',
                onTap: () => setState(() => _locationType = 'rural'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _BigIconCard(
                icon: Icons.location_city,
                label: l10n.loc_urban,
                color: Colors.orange,
                isSelected: _locationType == 'urban',
                onTap: () => setState(() => _locationType = 'urban'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStateSection(AppLocalizations l10n) {
    final Map<String, String> states = {
      'Andhra Pradesh': l10n.state_andhra,
      'Arunachal Pradesh': l10n.state_arunachal,
      'Assam': l10n.state_assam,
      'Bihar': l10n.state_bihar,
      'Chhattisgarh': l10n.state_chhattisgarh,
      'Goa': l10n.state_goa,
      'Gujarat': l10n.state_gujarat,
      'Haryana': l10n.state_haryana,
      'Himachal Pradesh': l10n.state_himachal,
      'Jharkhand': l10n.state_jharkhand,
      'Karnataka': l10n.state_karnataka,
      'Kerala': l10n.state_kerala,
      'Madhya Pradesh': l10n.state_mp,
      'Maharashtra': l10n.state_maharashtra,
      'Manipur': l10n.state_manipur,
      'Meghalaya': l10n.state_meghalaya,
      'Mizoram': l10n.state_mizoram,
      'Nagaland': l10n.state_nagaland,
      'Odisha': l10n.state_odisha,
      'Punjab': l10n.state_punjab,
      'Rajasthan': l10n.state_rajasthan,
      'Sikkim': l10n.state_sikkim,
      'Tamil Nadu': l10n.state_tn,
      'Telangana': l10n.state_telangana,
      'Tripura': l10n.state_tripura,
      'Uttar Pradesh': l10n.state_up,
      'Uttarakhand': l10n.state_uttarakhand,
      'West Bengal': l10n.state_wb,
      'Andaman & Nicobar': l10n.ut_andaman,
      'Chandigarh': l10n.ut_chandigarh,
      'Dadra & Nagar Haveli and Daman & Diu': l10n.ut_dadra,
      'Delhi': l10n.ut_delhi,
      'Jammu & Kashmir': l10n.ut_jk,
      'Ladakh': l10n.ut_ladakh,
      'Lakshadweep': l10n.ut_lakshadweep,
      'Puducherry': l10n.ut_puducherry,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslatedText(
          l10n.q_state,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[300]!, width: 1.5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedState,
              hint: AutoTranslatedText(l10n.select_state_hint),
              items: states.entries.map((entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: AutoTranslatedText(entry.value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedState = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLandOwnershipSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslatedText(
          l10n.q_land_ownership,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _SmallIconCard(
              icon: Icons.do_not_step,
              label: l10n.land_none,
              isSelected: _landOwnership == 'landless',
              onTap: () => setState(() => _landOwnership = 'landless'),
            ),
            _SmallIconCard(
              icon: Icons.grass,
              label: l10n.land_small,
              isSelected: _landOwnership == 'small_land',
              onTap: () => setState(() => _landOwnership = 'small_land'),
            ),
            _SmallIconCard(
              icon: Icons.agriculture,
              label: l10n.land_large,
              isSelected: _landOwnership == 'large_land',
              onTap: () => setState(() => _landOwnership = 'large_land'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubmitButton(AppLocalizations l10n) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _submitProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: AutoTranslatedText(
          l10n.find_my_schemes,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _BigIconCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _BigIconCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.15) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 3 : 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 56, color: isSelected ? color : Colors.grey[600]),
            const SizedBox(height: 12),
            AutoTranslatedText(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? color : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmallIconCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SmallIconCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 72) / 3;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: cardWidth,
        height: 110,
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.purple.withValues(alpha: 0.15)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.grey[300]!,
            width: isSelected ? 3 : 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.purple : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: AutoTranslatedText(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.purple : Colors.grey[700],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FrequencyButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isFirst;
  final bool isLast;

  const _FrequencyButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.purple.withValues(alpha: 0.15)
                : Colors.white,
            borderRadius: BorderRadius.horizontal(
              left: isFirst ? const Radius.circular(15) : Radius.zero,
              right: isLast ? const Radius.circular(15) : Radius.zero,
            ),
            border: Border(
              right: !isLast
                  ? BorderSide(color: Colors.grey[300]!, width: 1)
                  : BorderSide.none,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isSelected)
                const Padding(
                  padding: EdgeInsets.only(right: 4),
                  child: Icon(Icons.check, size: 18, color: Colors.purple),
                ),
              AutoTranslatedText(
                label,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? Colors.purple : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
