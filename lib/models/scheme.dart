import 'package:hive/hive.dart';

part 'scheme.g.dart';

@HiveType(typeId: 0)
class Scheme {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String description;
  @HiveField(3)
  final Map<String, String> translatedNames;
  @HiveField(4)
  final Map<String, String> translatedDescriptions;
  @HiveField(5)
  final Map<String, dynamic> rules;
  @HiveField(6)
  final List<String> requiredDocuments;
  @HiveField(7)
  final String applicationUrl;

  @HiveField(8)
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
    this.benefitAmount = "Variable",
  });
}
