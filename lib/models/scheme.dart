class Scheme {
  final String id;
  final String name;
  final String description;
  final Map<String, dynamic> rules;
  final List<String> requiredDocuments;

  Scheme({
    required this.id,
    required this.name,
    required this.description,
    required this.rules,
    required this.requiredDocuments,
  });
}
