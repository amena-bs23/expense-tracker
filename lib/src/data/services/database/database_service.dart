import 'package:sqflite/sqflite.dart';

/// Abstract database service to allow swapping implementations (e.g., Sqflite).
abstract class DatabaseService {
  Future<void> initialize();

  Database get db;

  // User APIs
  Future<int> insertUser(Map<String, Object?> data);
  Future<Map<String, Object?>?> findUserByEmail(String email);

  // Category APIs
  Future<int> insertCategory(Map<String, Object?> data);
  Future<int> updateCategory(Map<String, Object?> data);
  Future<int> deleteCategory(int id);
  Future<List<Map<String, Object?>>> getAllCategories();

  // Expense APIs
  Future<int> insertExpense(Map<String, Object?> data);
  Future<int> deleteExpense(int id);
  Future<List<Map<String, Object?>>> getAllExpenses();
}


