import '../models/scheme.dart';
import 'database_helper.dart';

// Start with an empty list. It will be populated from SQLite at runtime.
List<Scheme> schemesDatabase = [];

/// Call this function at app startup to load schemes from the offline SQLite DB
Future<void> loadSchemesFromLocalDb() async {
  try {
    schemesDatabase = await DatabaseHelper().getAllSchemes();
    print("Loaded ${schemesDatabase.length} schemes from local DB");
  } catch (e) {
    print("Error loading schemes from DB: $e");
    // Fallback or empty
    schemesDatabase = [];
  }
}
