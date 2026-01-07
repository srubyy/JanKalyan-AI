import '../models/scheme.dart';
import '../models/user_profile.dart';

class EligibilityEngine {
  static bool isEligible(UserProfile profile, Scheme scheme) {
    final rules = scheme.rules;

    if (rules.containsKey("gender") && rules["gender"] != profile.gender) {
      return false;
    }

    if (rules.containsKey("occupation") &&
        rules["occupation"] != profile.occupation) {
      return false;
    }

    if (rules.containsKey("maxIncome") &&
        profile.income > rules["maxIncome"]) {
      return false;
    }

    if (rules.containsKey("minAge") && profile.age < rules["minAge"]) {
      return false;
    }

    return true;
  }
}
