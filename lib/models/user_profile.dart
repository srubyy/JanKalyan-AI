class UserProfile {
  /// Core demographics
  final int age;                 // e.g. 25
  final String gender;           // Male / Female / Transgender
  final double income;           // Annual income (numeric)
  final String occupation;       // Farmer / Student / Worker / Unemployed
  final String state;            // Maharashtra, Gujarat, etc.

  /// Optional but powerful eligibility fields
  final String? socialCategory;  // SC / ST / OBC / General
  final String? specialCategory; // Disability / Widow / Single Parent / Transgender

  const UserProfile({
    required this.age,
    required this.gender,
    required this.income,
    required this.occupation,
    required this.state,
    this.socialCategory,
    this.specialCategory,
  });

  /// Useful for debugging / logs
  @override
  String toString() {
    return '''
UserProfile(
  age: $age,
  gender: $gender,
  income: $income,
  occupation: $occupation,
  state: $state,
  socialCategory: $socialCategory,
  specialCategory: $specialCategory
)
''';
  }
}
