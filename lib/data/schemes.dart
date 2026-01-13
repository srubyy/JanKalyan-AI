import '../models/scheme.dart';
import 'hive_service.dart';

// Global cache
List<Scheme> schemesDatabase = [];

/// Load schemes from Hive into memory
Future<void> loadSchemesFromLocalDb() async {
  schemesDatabase = HiveService.getSchemes();
  print("Loaded ${schemesDatabase.length} schemes from Hive");
}
