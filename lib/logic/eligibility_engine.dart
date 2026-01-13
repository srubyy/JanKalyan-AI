import '../models/scheme.dart';
import '../models/user_profile.dart';

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
  /// Pure deterministic evaluation of scheme eligibility.
  /// Returns a boolean as requested.
  static bool isEligible(UserProfile user, Scheme scheme) {
    return evaluate(user, scheme).status == EligibilityStatus.eligible;
  }

  /// Detailed evaluation returning status and reasons.
  /// This maintains compatibility with UI components that expect detailed results.
  static EligibilityResult evaluate(UserProfile user, Scheme scheme) {
    // Strict Rule: If rules are empty, scheme is treated as NOT eligible.
    if (scheme.rules.isEmpty) {
      return _notEligible();
    }

    final rules = scheme.rules;
    final reasons = <String>[];

    bool hasRule(String key) => rules.containsKey(key);

    List<String> getRuleList(String key) {
      if (!rules.containsKey(key)) return [];
      final val = rules[key];
      if (val is String) return [val.toLowerCase().trim()];
      if (val is List)
        return val.map((e) => e.toString().toLowerCase().trim()).toList();
      return [];
    }

    // --- 1. Gender Check (CRITICAL) ---
    // If a scheme specifies a gender requirement, strict matching is enforced.
    // Male users will be rejected for female-only schemes if defined in rules.
    if (hasRule('gender')) {
      final allowed = getRuleList('gender');
      final userGender = user.gender.toLowerCase().trim();

      if (!allowed.contains(userGender)) {
        return _notEligible();
      }
      reasons.add('Gender matches');
    }

    // --- 2. Age Check ---
    if (hasRule('minAge')) {
      final minAge = num.tryParse(rules['minAge'].toString());
      if (minAge != null && user.age < minAge) {
        return _notEligible();
      }
    }
    if (hasRule('maxAge')) {
      final maxAge = num.tryParse(rules['maxAge'].toString());
      if (maxAge != null && user.age > maxAge) {
        return _notEligible();
      }
    }
    if (hasRule('minAge') || hasRule('maxAge')) {
      reasons.add('Age requirements met');
    }

    // --- 3. Income Check ---
    if (hasRule('maxIncome')) {
      final maxIncome = num.tryParse(rules['maxIncome'].toString());
      if (maxIncome != null && user.income > maxIncome) {
        return _notEligible();
      }
      reasons.add('Income within limit');
    }

    // --- 4. Special Category Check (Strict) ---
    if (hasRule('specialCategory')) {
      final allowed = getRuleList('specialCategory');
      // User MUST have the category. Missing = Ineligible.
      if (user.specialCategory == null) {
        return _notEligible();
      }
      final userCat = user.specialCategory!.toLowerCase().trim();
      if (!allowed.contains(userCat)) {
        return _notEligible();
      }
      reasons.add('Special Category matches');
    }

    // --- 5. Social Category Check (Strict) ---
    if (hasRule('socialCategory')) {
      final allowed = getRuleList('socialCategory');
      if (user.socialCategory == null) {
        return _notEligible();
      }
      final userCat = user.socialCategory!.toLowerCase().trim();
      if (!allowed.contains(userCat)) {
        return _notEligible();
      }
      reasons.add('Social Category matches');
    }

    // --- 6. Occupation Check ---
    if (hasRule('occupation')) {
      final allowed = getRuleList('occupation');
      final userOcc = user.occupation.toLowerCase().trim();
      if (!allowed.contains(userOcc)) {
        return _notEligible();
      }
      reasons.add('Occupation matches');
    }

    // --- 7. State Check ---
    if (hasRule('state')) {
      final allowed = getRuleList('state');
      // Check for Pan-India
      if (allowed.contains('india')) {
        reasons.add('Available across India');
      } else {
        if (user.state == null) {
          return _notEligible();
        }
        final userState = user.state!.toLowerCase().trim();
        if (!allowed.contains(userState)) {
          return _notEligible();
        }
        reasons.add('Available in ${user.state}');
      }
    }

    // If all checks passed
    return EligibilityResult(
      status: EligibilityStatus.eligible,
      reasons: reasons,
      missing: [],
    );
  }

  static EligibilityResult _notEligible() {
    return EligibilityResult(
      status: EligibilityStatus.notEligible,
      reasons: [],
      missing: [],
    );
  }
}
