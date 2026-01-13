import '../models/scheme.dart';
import 'hive_service.dart';

// Start with an empty list. It will be populated from Hive at runtime.
List<Scheme> schemesDatabase = [];

/// Call this function at app startup to load schemes from the offline Hive DB
Future<void> loadSchemesFromLocalDb() async {
  try {
    await HiveService.init();
    schemesDatabase = HiveService.getSchemes();
    print("Loaded ${schemesDatabase.length} schemes from Hive DB");
  } catch (e) {
    print("Error loading schemes from Hive: $e");
    // Fallback or empty
    schemesDatabase = [];
  }
}
