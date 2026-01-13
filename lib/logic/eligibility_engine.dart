import '../models/user_profile.dart';
import '../models/scheme.dart';

enum EligibilityStatus { eligible, nearlyEligible, notEligible }

class EligibilityResult {
  final EligibilityStatus status;
  final List<String> reasons;
  final List<String> missing;

  EligibilityResult({
    required this.status,
    required this.reasons,
    required this.missing,
  });
}

class EligibilityEngine {
  static EligibilityResult evaluate(UserProfile user, Scheme scheme) {
    final reasons = <String>[];
    final missing = <String>[];
    int failed = 0;

    final rules = scheme.rules;

    // AGE
    if (rules['minAge'] != null && user.age < rules['minAge']) {
      failed++;
    }
    if (rules['maxAge'] != null && user.age > rules['maxAge']) {
      failed++;
    }
    if (rules['minAge'] != null || rules['maxAge'] != null) {
      reasons.add('Age requirement satisfied');
    }

    // GENDER
    if (rules['gender'] != null && rules['gender'].isNotEmpty) {
      if (!rules['gender'].contains(user.gender)) {
        failed++;
      } else {
        reasons.add('Gender eligible');
      }
    }

    // OCCUPATION
    if (rules['occupation'] != null && rules['occupation'].isNotEmpty) {
      if (!rules['occupation'].contains(user.occupation)) {
        failed++;
      } else {
        reasons.add('Occupation eligible');
      }
    }

    // STATE
    if (rules['state'] != null && rules['state'].isNotEmpty) {
      if (!rules['state'].contains(user.state)) {
        failed++;
      } else {
        reasons.add('Scheme available in your state');
      }
    }

    // INCOME
    if (rules['maxIncome'] != null) {
      if (user.income > rules['maxIncome']) {
        failed++;
      } else {
        reasons.add('Income within allowed limit');
      }
    }

    // SOCIAL CATEGORY (optional)
    if (rules['socialCategory'] != null && rules['socialCategory'].isNotEmpty) {
      if (user.socialCategory == null) {
        missing.add('Social category not provided');
      } else if (!rules['socialCategory'].contains(user.socialCategory)) {
        failed++;
      } else {
        reasons.add('Social category eligible');
      }
    }

    // SPECIAL CATEGORY (optional)
    if (rules['specialCategory'] != null &&
        rules['specialCategory'].isNotEmpty) {
      if (user.specialCategory == null) {
        missing.add('Special category not provided');
      } else if (!rules['specialCategory'].contains(user.specialCategory)) {
        failed++;
      } else {
        reasons.add('Special category eligible');
      }
    }

    // FINAL DECISION
    if (failed == 0 && missing.isEmpty) {
      return EligibilityResult(
        status: EligibilityStatus.eligible,
        reasons: reasons,
        missing: [],
      );
    }

    if (failed == 0 && missing.isNotEmpty) {
      return EligibilityResult(
        status: EligibilityStatus.nearlyEligible,
        reasons: reasons,
        missing: missing,
      );
    }

    return EligibilityResult(
      status: EligibilityStatus.notEligible,
      reasons: [],
      missing: [],
    );
  }
}
