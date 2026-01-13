class Normalizers {
  static String gender(String input) {
    switch (input.toLowerCase()) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      case 'transgender':
        return 'Transgender';
      default:
        return 'Unknown';
    }
  }

  static String occupation(String input) {
    switch (input.toLowerCase()) {
      case 'farmer':
        return 'Farmer';
      case 'student':
        return 'Student';
      case 'worker':
        return 'Worker';
      case 'unemployed':
        return 'Unemployed';
      default:
        return 'Other';
    }
  }

  static String location(String input) {
    return input.toLowerCase() == 'urban' ? 'Urban' : 'Rural';
  }
}
