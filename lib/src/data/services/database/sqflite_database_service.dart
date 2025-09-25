import 'dart:async';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'database_service.dart';

class SqfliteDatabaseService implements DatabaseService {
  Database? _database;

  static const String _dbName = 'expense_tracker.db';
  static const int _dbVersion = 1;

  // Tables
  static const String tableUsers = 'users';
  static const String tableCategories = 'categories';

  // User columns
  static const String colUserId = 'id';
  static const String colUserEmail = 'email';
  static const String colUserFirstName = 'first_name';
  static const String colUserLastName = 'last_name';
  static const String colUserPasswordHash = 'password_hash';
  static const String colUserCreatedAt = 'created_at';

  @override
  Database get db => _database!;

  @override
  Future<void> initialize() async {
    if (_database != null) return;

    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(dir.path, _dbName);

    _database = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableUsers (
            $colUserId INTEGER PRIMARY KEY AUTOINCREMENT,
            $colUserEmail TEXT UNIQUE NOT NULL,
            $colUserFirstName TEXT NOT NULL,
            $colUserLastName TEXT NOT NULL,
            $colUserPasswordHash TEXT NOT NULL,
            $colUserCreatedAt INTEGER NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE $tableCategories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT UNIQUE NOT NULL,
            icon TEXT NOT NULL,
            color INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<int> insertUser(Map<String, Object?> data) async {
    return db.insert(tableUsers, data, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  @override
  Future<Map<String, Object?>?> findUserByEmail(String email) async {
    final res = await db.query(
      tableUsers,
      where: '$colUserEmail = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (res.isEmpty) return null;
    return res.first;
  }

  @override
  Future<int> insertCategory(Map<String, Object?> data) {
    return db.insert(tableCategories, data, conflictAlgorithm: ConflictAlgorithm.abort);
  }

  @override
  Future<int> updateCategory(Map<String, Object?> data) {
    return db.update(
      tableCategories,
      data,
      where: 'id = ?',
      whereArgs: [data['id']],
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  @override
  Future<int> deleteCategory(int id) {
    return db.delete(
      tableCategories,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Map<String, Object?>>> getAllCategories() async {
    return db.query(tableCategories, orderBy: 'name ASC');
  }
}


