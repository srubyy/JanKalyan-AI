import '../models/scheme.dart';
import '../models/user_profile.dart';

class EligibilityEngine {
  static bool isEligible(UserProfile profile, Scheme scheme) {
    // 🛡️ Guard: Default to true if no rules, but better to be strict? 
    // Usually schemes have specific criteria. If rules map is empty, arguably it's open for all.
    final rules = scheme.rules;
    if (rules.isEmpty) return true;

    // 1️⃣ GENDER Check
    if (rules.containsKey("gender")) {
      final reqGender = rules["gender"].toString().toLowerCase();
      // If rule is "female", profile must be female.
      // If rule is "male", profile must be male.
      // If profile is "other", they might miss out unless explicitly included.
      if (reqGender != "all" && reqGender != profile.gender.toLowerCase()) {
        return false;
      }
    }

    // 2️⃣ AGE Check
    // Supports "minAge", "maxAge", or "ageRange" (e.g. "18-40")
    if (rules.containsKey("minAge")) {
      final min = int.tryParse(rules["minAge"].toString()) ?? 0;
      if (profile.age < min) return false;
    }
    if (rules.containsKey("maxAge")) {
      final max = int.tryParse(rules["maxAge"].toString()) ?? 100;
      if (profile.age > max) return false;
    }
    if (rules.containsKey("ageRange")) {
      // expected format "18-60"
      final parts = rules["ageRange"].toString().split("-");
      if (parts.length == 2) {
        final rMin = int.tryParse(parts[0]) ?? 0;
        final rMax = int.tryParse(parts[1]) ?? 100;
        if (profile.age < rMin || profile.age > rMax) return false;
      }
    }

    // 3️⃣ INCOME Check (Upper Limit)
    if (rules.containsKey("maxIncome")) {
      final limit = double.tryParse(rules["maxIncome"].toString()) ?? 0;
      // If profile income > limit -> Ineligible
      if (profile.income > limit) return false;
    }
    if (rules.containsKey("incomeBelow")) {
       // e.g. "250000" or text "2.5 Lakh" (db has numeric strings mostly)
       // We'll try to parse just in case
       // Simple heuristic: remove non-digits
       final text = rules["incomeBelow"].toString();
       final clean = text.replaceAll(RegExp(r'[^0-9]'), '');
       if (clean.isNotEmpty) {
         final limit = double.tryParse(clean) ?? 0;
         if (profile.income > limit) return false;
       }
    }

    // 4️⃣ OCCUPATION & CONTEXT Check (Strict Keyword Matching)
    // Combine all descriptive rule values to infer constraints
    final contextText = [
      scheme.name,
      scheme.description,
      rules['beneficiary'],
      rules['eligibility'],
      rules['eligible'], // DB uses this key too
      rules['focus'],
      rules['loanType'], // e.g. "Education Loan" -> Student
      rules['cropType'], // -> Farmer
    ].where((e) => e != null).join(" ").toLowerCase();

    final userOcc = profile.occupation.toLowerCase();
    
    // --- Occupation Inference ---
    final isSchemeForFarmers = contextText.contains("farmer") || contextText.contains("kisan") || contextText.contains("agriculture") || contextText.contains("crop") || contextText.contains("harvest");
    final isSchemeForStudents = contextText.contains("student") || contextText.contains("scholarship") || contextText.contains("education") || contextText.contains("school") || contextText.contains("college") || contextText.contains("university") || contextText.contains("fellowship") || contextText.contains("academic");
    final isSchemeForWorkers = contextText.contains("worker") || contextText.contains("labour") || contextText.contains("shram") || contextText.contains("wage") || contextText.contains("artisan") || contextText.contains("handicraft") || contextText.contains("mason");

    // Strict Occupation Filtering
    if (isSchemeForFarmers && !userOcc.contains("farmer")) return false;
    
    if (isSchemeForStudents && !userOcc.contains("student")) {
       // Allow if user is '0-18' (child implies student context often) but valid check matches 
       if (profile.age > 18) return false; 
    }
    
    if (isSchemeForWorkers) {
       if (!userOcc.contains("worker") && !userOcc.contains("artisan") && !userOcc.contains("self_employed")) return false;
    }

    // --- Gender Inference ---
    final isFemaleOnly = contextText.contains("women") || contextText.contains("bhagini") || contextText.contains("ladies") || contextText.contains("mahila") || contextText.contains("girl") || contextText.contains("pregnancy") || contextText.contains("maternal") || contextText.contains("widow") || contextText.contains("mother");
    
    if (isFemaleOnly) {
       if (profile.gender.toLowerCase() != "female") return false;
    }

    // --- Special Category Inference (Widow, Disability) ---
    final userSpecial = (profile.specialCategory ?? "").toLowerCase();
    
    // STRICT RULE: If scheme mentions "widow", user MUST be widow.
    if (contextText.contains("widow") || contextText.contains("vidhwa")) {
       if (!userSpecial.contains("widow")) return false;
    }
    
    // STRICT RULE: If scheme is Disability-specific
    if (contextText.contains("disability") || contextText.contains("handicap") || contextText.contains("divyang") || contextText.contains("blind")) {
       if (!userSpecial.contains("disability")) return false;
    }
    
    if (contextText.contains("transgender")) {
       if (!userSpecial.contains("transgender")) return false;
    }

    // --- Gender Inference ---
    // If scheme is Female-only (women/girl/etc)
    final isFemaleSpecific = contextText.contains("women") || contextText.contains("bhagini") || contextText.contains("ladies") || contextText.contains("mahila") || contextText.contains("girl") || contextText.contains("pregnancy") || contextText.contains("maternal") || contextText.contains("mother");
    
    if (isFemaleSpecific) {
       if (profile.gender.toLowerCase() != "female") return false;
    }
    
    // NOTE: A Widow is Female. So she passes (Gender check = True).
    // She encounters "Widow Scheme" -> Context has "Widow" -> She is Widow -> Passes.
    // She encounters "Women Scheme" -> Context has "Women" (no "Widow") -> She is Female -> Passes.
    // A Non-Widow Female:
    // Encounters "Widow Scheme" -> Context has "Widow" -> She is NOT Widow -> Fails.
    // Encounters "Women Scheme" -> Context has "Women" -> She is Female -> Passes.
    
    // This logic holds.

    // e.g. if text says "for SC/ST only" but keys missed it
    final userCat = (profile.socialCategory ?? "General").toLowerCase();
    if (contextText.contains("scheduled caste") || contextText.contains(" sc ") || contextText.contains("(sc)")) {
       // If scheme mentions SC, but user is NOT SC (and not ST if grouped), exclude?
       // Risks exclusion if "SC and General". Use caution.
       // Only exclude if it explicitly says "only for sc" which is hard to parse.
       // However, checking the specific 'category' key below is safer.
       // But 'beneficiary' might say "SC Students".
       if (contextText.contains("students")) { // e.g. "SC Students"
          // If context has "SC" and User is "General", likely ineligible
          if ((contextText.contains(" sc ") || contextText.contains("scheduled caste"))) {
             if (!userCat.contains("sc") && !userCat.contains("scheduled caste")) {
                // Check if it allows others? Too risky? 
                // Let's rely on explicit category key mostly, but strictly enforce if "Only" detected?
                // For now, strict mapping:
                // If it mentions SC but not ST/OBC/General, and user is General -> Block
                bool mentionsST = contextText.contains(" st ") || contextText.contains("scheduled tribe");
                bool mentionsOBC = contextText.contains(" obc ") || contextText.contains("backward class");
                bool mentionsGeneral = contextText.contains("general") || contextText.contains("open category");
                
                if (!mentionsST && !mentionsOBC && !mentionsGeneral) {
                   // Seemingly SC only
                   if (!userCat.contains("sc")) return false;
                }
             }
          }
       }
    }


    // 5️⃣ STATE Residence Check
    if (rules.containsKey("state")) {
       final reqState = rules["state"].toString().toLowerCase();
       final userState = (profile.state ?? "").toLowerCase();
       if (reqState != "all" && reqState != "india" && reqState != "central") {
         if (userState.isNotEmpty && reqState != userState) {
           return false;
         }
       }
    } else {
      // Heuristic State Check
      final lowerName = scheme.name.toLowerCase();
      final userState = (profile.state ?? "").toLowerCase();
      if (lowerName.contains("maharashtra") && userState != "maharashtra") return false;
      if (lowerName.contains("gujarat") && userState != "gujarat") return false;
      // ... match other states if needed
    }

    // 6️⃣ SOCIAL CATEGORY (Explicit Key Check)
    if (rules.containsKey("category")) {
      final reqCat = rules["category"].toString().toLowerCase();
      
      if (reqCat != "all" && reqCat != "general") {
         if (!userCat.contains(reqCat)) {
           // Handle combined "sc/st"
           if (reqCat.contains("/")) {
             final options = reqCat.split("/");
             bool match = false;
             for (var opt in options) {
               if (userCat.contains(opt.trim())) match = true;
             }
             if (!match) return false;
           } else {
             // Handle "backward class" matching "obc", "sc", "st"
             if (reqCat.contains("backward") && (userCat == "sc" || userCat == "st" || userCat == "obc")) {
               // eligible
             } else {
               return false;
             }
           }
         }
      }
    }

    // 7️⃣ PREGNANCY / HEALTH
    if (rules.containsKey("pregnancy") || contextText.contains("pregnant")) {
       // We don't ask "Are you pregnant?" but we can at least enforce gender
       if (profile.gender.toLowerCase() != "female") return false;
    }
    
    // 8️⃣ LAND OWNERSHIP
    if (rules.containsKey("land")) {
      final landRule = rules["land"].toString().toLowerCase();
      final userLand = (profile.landOwnership ?? "").toLowerCase();
      if (landRule.contains("small") && userLand == "large_land") return false;
      if (landRule.contains("landless") && userLand != "landless") return false;
    }

    return true;
  }
}
