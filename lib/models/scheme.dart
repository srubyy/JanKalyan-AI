class Scheme {
  final String id;
  final String name; 
  final String description;
  final Map<String, String> translatedNames;
  final Map<String, String> translatedDescriptions;
  final Map<String, dynamic> rules;
  final List<String> requiredDocuments;
  final String applicationUrl;

  final String benefitAmount;

  Scheme({
    required this.id,
    required this.name,
    required this.description,
    this.translatedNames = const {},
    this.translatedDescriptions = const {},
    required this.rules,
    required this.requiredDocuments,
    this.applicationUrl = 'https://www.india.gov.in/',
    this.benefitAmount = '', 
  });
}
