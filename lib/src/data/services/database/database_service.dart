import 'package:sqflite/sqflite.dart';

/// Abstract database service to allow swapping implementations (e.g., Sqflite).
abstract class DatabaseService {
  Future<void> initialize();

  Database get db;

  // User APIs
  Future<int> insertUser(Map<String, Object?> data);
  Future<Map<String, Object?>?> findUserByEmail(String email);
}


