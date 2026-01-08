// lib/screens/profile_quiz_screen.dart

import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/user_profile.dart';
import 'processing_screen.dart';

class ProfileQuizScreen extends StatefulWidget {
  const ProfileQuizScreen({super.key});

  @override
  State<ProfileQuizScreen> createState() => _ProfileQuizScreenState();
}

class _ProfileQuizScreenState extends State<ProfileQuizScreen> {
  int _currentStep = 0;

  String? _ageGroup;
  String? _gender;
  String? _incomeRange;
  String? _occupation;
  String? _socialCategory;
  String? _specialCategory;

  final int _totalSteps = 7;

  void _selectOption(String value) {
    setState(() {
      switch (_currentStep) {
        case 0:
          _ageGroup = value;
          break;
        case 1:
          _gender = value;
          break;
        case 2:
          _incomeRange = value;
          break;
        case 3:
          _occupation = value;
          break;
        case 4:
          // State - auto-set to Maharashtra
          break;
        case 5:
          _socialCategory = value;
          break;
        case 6:
          _specialCategory = value;
          break;
      }
      _nextStep();
    });
  }

  void _skip() {
    setState(() {
      if (_currentStep == 5) {
        _socialCategory = null;
      } else if (_currentStep == 6) {
        _specialCategory = null;
      }
      _nextStep();
    });
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      _completeQuiz();
    }
  }

  void _completeQuiz() {
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

    double income;
    if (_incomeRange == 'below_1l') {
      income = 90000;
    } else if (_incomeRange == '1l_2_5l') {
      income = 150000;
    } else if (_incomeRange == '2_5l_5l') {
      income = 350000;
    } else {
      income = 600000;
    }

    final profile = UserProfile(
      age: age,
      gender: _gender!,
      income: income,
      occupation: _occupation!,
      locationType: 'rural',
      socialCategory: _socialCategory,
      specialCategory: _specialCategory,
      state: 'Maharashtra',
    );

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ProcessingScreen(profile: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Auto-advance for Maharashtra state question
    if (_currentStep == 4) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _nextStep();
        }
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(child: _buildCurrentQuestion(l10n)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentStep + 1} / $_totalSteps',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_currentStep + 1) / _totalSteps,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentQuestion(AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return _buildAgeQuestion(l10n);
      case 1:
        return _buildGenderQuestion(l10n);
      case 2:
        return _buildIncomeQuestion(l10n);
      case 3:
        return _buildOccupationQuestion(l10n);
      case 4:
        return _buildStateQuestion(l10n);
      case 5:
        return _buildSocialCategoryQuestion(l10n);
      case 6:
        return _buildSpecialCategoryQuestion(l10n);
      default:
        return const SizedBox();
    }
  }

  Widget _buildAgeQuestion(AppLocalizations l10n) {
    return _QuestionLayout(
      icon: Icons.cake,
      title: l10n.q_age,
      options: [
        _OptionData('0-18', Icons.child_care, l10n.age_0_18),
        _OptionData('18-25', Icons.school, l10n.age_18_25),
        _OptionData('26-40', Icons.work, l10n.age_26_40),
        _OptionData('41-60', Icons.business_center, l10n.age_41_60),
        _OptionData('60+', Icons.elderly, l10n.age_60_plus),
      ],
      onSelect: _selectOption,
    );
  }

  Widget _buildGenderQuestion(AppLocalizations l10n) {
    return _QuestionLayout(
      icon: Icons.person,
      title: l10n.q_gender,
      options: [
        _OptionData('male', Icons.man, l10n.gender_male),
        _OptionData('female', Icons.woman, l10n.gender_female),
        _OptionData('other', Icons.person_outline, l10n.gender_other),
      ],
      onSelect: _selectOption,
    );
  }

  Widget _buildIncomeQuestion(AppLocalizations l10n) {
    return _QuestionLayout(
      icon: Icons.currency_rupee,
      title: l10n.q_income,
      options: [
        _OptionData('below_1l', Icons.money_off, l10n.income_below_1l),
        _OptionData('1l_2_5l', Icons.attach_money, l10n.income_1l_2_5l),
        _OptionData(
          '2_5l_5l',
          Icons.account_balance_wallet,
          l10n.income_2_5l_5l,
        ),
        _OptionData('above_5l', Icons.payments, l10n.income_above_5l),
      ],
      onSelect: _selectOption,
    );
  }

  Widget _buildOccupationQuestion(AppLocalizations l10n) {
    return _QuestionLayout(
      icon: Icons.work,
      title: l10n.q_occupation,
      options: [
        _OptionData('farmer', Icons.agriculture, l10n.occ_farmer),
        _OptionData('student', Icons.school, l10n.occ_student),
        _OptionData('worker', Icons.construction, l10n.occ_worker),
        _OptionData('artisan', Icons.handyman, l10n.occ_artisan),
        _OptionData('homemaker', Icons.home, l10n.occ_homemaker),
        _OptionData('self_employed', Icons.business, l10n.occ_self_employed),
      ],
      onSelect: _selectOption,
    );
  }

  Widget _buildStateQuestion(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_on, size: 80, color: Colors.blue),
          const SizedBox(height: 24),
          Text(
            l10n.state_maharashtra,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialCategoryQuestion(AppLocalizations l10n) {
    return _QuestionLayout(
      icon: Icons.group,
      title: l10n.q_social_category,
      options: [
        _OptionData('SC', Icons.people, l10n.social_sc),
        _OptionData('ST', Icons.people_outline, l10n.social_st),
        _OptionData('OBC', Icons.groups, l10n.social_obc),
        _OptionData('General', Icons.person, l10n.social_general),
      ],
      onSelect: _selectOption,
      showSkip: true,
      onSkip: _skip,
      skipLabel: l10n.skip,
    );
  }

  Widget _buildSpecialCategoryQuestion(AppLocalizations l10n) {
    return _QuestionLayout(
      icon: Icons.accessibility_new,
      title: l10n.q_special_category,
      options: [
        _OptionData('disability', Icons.accessible, l10n.special_disability),
        _OptionData('widow', Icons.woman, l10n.special_widow),
        _OptionData(
          'single_parent',
          Icons.family_restroom,
          l10n.special_single_parent,
        ),
        _OptionData('transgender', Icons.transgender, l10n.special_transgender),
      ],
      onSelect: _selectOption,
      showSkip: true,
      onSkip: _skip,
      skipLabel: l10n.skip,
    );
  }
}

class _OptionData {
  final String value;
  final IconData icon;
  final String label;

  _OptionData(this.value, this.icon, this.label);
}

class _QuestionLayout extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<_OptionData> options;
  final Function(String) onSelect;
  final bool showSkip;
  final VoidCallback? onSkip;
  final String? skipLabel;

  const _QuestionLayout({
    required this.icon,
    required this.title,
    required this.options,
    required this.onSelect,
    this.showSkip = false,
    this.onSkip,
    this.skipLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Icon(icon, size: 64, color: Colors.blue),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView.separated(
              itemCount: options.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final option = options[index];
                return _OptionCard(
                  icon: option.icon,
                  label: option.label,
                  onTap: () => onSelect(option.value),
                );
              },
            ),
          ),
          if (showSkip) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onSkip ?? () {},
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: Text(
                skipLabel ?? 'Skip',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 40, color: Colors.blue),
                const SizedBox(width: 24),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
