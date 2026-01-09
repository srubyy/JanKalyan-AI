import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/scheme.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'schemes.db');

    // Check if the database exists
    final exists = await databaseExists(path);

    if (!exists) {
      // Should happen only the first time you launch your application
      print("Creating new copy from asset");

      // Make sure the parent directory exists
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "schemes.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("Opening existing database");
    }

    // open the database
    return await openDatabase(path, readOnly: true);
  }

  Future<List<Scheme>> getAllSchemes() async {
    final db = await database;

    // Get all schemes
    final List<Map<String, dynamic>> schemeMaps = await db.query('schemes');
    
    List<Scheme> schemes = [];

    for (var schemeMap in schemeMaps) {
      String id = schemeMap['id'];
      
      // Get translations
      final List<Map<String, dynamic>> translationMaps = await db.query(
        'scheme_translations',
        where: 'schemeId = ?',
        whereArgs: [id],
      );
      
      Map<String, String> translatedNames = {};
      Map<String, String> translatedDescriptions = {};
      
      for (var t in translationMaps) {
        translatedNames[t['language']] = t['translatedName'];
        translatedDescriptions[t['language']] = t['translatedDescription'];
      }

      // Get rules
      final List<Map<String, dynamic>> rulesMaps = await db.query(
        'scheme_rules',
        where: 'schemeId = ?',
        whereArgs: [id],
      );
      
      Map<String, dynamic> rules = {};
      for (var r in rulesMaps) {
         // Simple heuristic to convert numeric strings back to numbers if possible, 
         // though for safety we can leave as string or check format.
         // 'maxIncome' and 'minAge' are commonly numbers.
         String key = r['ruleKey'];
         String value = r['ruleValue'];
         
         if (int.tryParse(value) != null) {
           rules[key] = int.parse(value);
         } else {
           rules[key] = value;
         }
      }

      // Get documents
      final List<Map<String, dynamic>> docMaps = await db.query(
        'scheme_documents',
        where: 'schemeId = ?',
        whereArgs: [id],
      );
      
      List<String> requiredDocuments = docMaps.map((d) => d['document'] as String).toList();

      schemes.add(Scheme(
        id: id,
        name: schemeMap['name'],
        description: schemeMap['description'],
        applicationUrl: schemeMap['applicationUrl'] ?? 'https://www.india.gov.in/',
        translatedNames: translatedNames,
        translatedDescriptions: translatedDescriptions,
        rules: rules,
        requiredDocuments: requiredDocuments,
      ));
    }

    return schemes;
  }
}
