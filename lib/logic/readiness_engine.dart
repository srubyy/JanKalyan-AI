import '../models/scheme.dart';

class ReadinessEngine {
  static double readinessScore(
      List<String> userDocuments, Scheme scheme) {
    int total = scheme.requiredDocuments.length;
    int present = userDocuments
        .where((doc) => scheme.requiredDocuments.contains(doc))
        .length;

    return (present / total) * 100;
  }

  static List<String> missingDocuments(
      List<String> userDocuments, Scheme scheme) {
    return scheme.requiredDocuments
        .where((doc) => !userDocuments.contains(doc))
        .toList();
  }
}
