class UserProfile {
  final String gender;            // Male / Female / Transgender
  final int age;                  // numeric age
  final double income;            // annual income
  final String occupation;        // Farmer / Student / Worker
  final String locationType;      // Rural / Urban
  final String? state;            // Maharashtra etc
  final String? socialCategory;   // SC / ST / OBC / GENERAL
  final String? specialCategory;  // Disability / Widow / Pregnant
  final String? landOwnership;    // Small / Marginal / Landless

  UserProfile({
    required this.gender,
    required this.age,
    required this.income,
    required this.occupation,
    required this.locationType,
    this.state,
    this.socialCategory,
    this.specialCategory,
    this.landOwnership,
  });

  @override
  String toString() {
    return 'UserProfile(gender: $gender, age: $age, income: $income, '
        'occupation: $occupation, location: $locationType, '
        'state: $state, social: $socialCategory, special: $specialCategory)';
  }
}
