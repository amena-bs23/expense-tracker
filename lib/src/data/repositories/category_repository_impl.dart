import '../../core/base/result.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../models/category_model.dart';
import '../services/database/database_service.dart';
import '../services/database/sqflite_database_service.dart';

final class CategoryRepositoryImpl extends CategoryRepository {
  CategoryRepositoryImpl(this._db);

  final DatabaseService _db;

  @override
  Future<List<CategoryEntity>> getAll() async {
    final rows = await _db.getAllCategories();
    return rows.map(CategoryModel.fromDb).toList();
  }

  // create implemented below

  @override
  Future<Result<CategoryEntity, String>> update(CategoryEntity data) async {
    try {
      final model = CategoryModel(
        id: data.id,
        name: data.name.trim(),
        icon: data.icon,
        color: data.color,
      );
      if ((await _db.db.query(
            SqfliteDatabaseService.tableCategories,
            where: 'name = ? AND id != ?',
            whereArgs: [model.name, model.id],
            limit: 1,
          ))
          .isNotEmpty) {
        return const Error('Category name already exists');
      }
      final count = await _db.updateCategory(model.toDb());
      if (count == 0) return const Error('Category not found');
      return Success(model);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<void, String>> delete(int id) async {
    try {
      await _db.deleteCategory(id);
      return const Success(null);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<void> preloadDefaultsIfEmpty() async {
    final rows = await _db.getAllCategories();
    if (rows.isNotEmpty) return;
    const defaults = [
      CategoryModel(name: 'Food', icon: 'restaurant', color: 0xFFFF7043),
      CategoryModel(name: 'Transport', icon: 'directions_bus', color: 0xFF42A5F5),
      CategoryModel(name: 'Entertainment', icon: 'movie', color: 0xFFAB47BC),
      CategoryModel(name: 'Health', icon: 'health_and_safety', color: 0xFF66BB6A),
      CategoryModel(name: 'Shopping', icon: 'shopping_bag', color: 0xFFFFCA28),
    ];
    for (final c in defaults) {
      try {
        await _db.insertCategory(c.toDb());
      } catch (_) {
        // ignore duplicates
      }
    }
  }

  @override
  Future<List<CategoryEntity>> backup() async {
    return getAll();
  }

  @override
  Future<void> restore(List<CategoryEntity> items) async {
    for (final e in items) {
      try {
        await _db.insertCategory(CategoryModel(
          name: e.name,
          icon: e.icon,
          color: e.color,
        ).toDb());
      } catch (_) {
        // skip duplicates
      }
    }
  }

  @override
  Future<Result<CategoryEntity, String>> create(CategoryEntity data) async {
    try {
      final name = data.name.trim();
      if (name.isEmpty) return const Error('Name required');
      if ((await _db.db.query(
            SqfliteDatabaseService.tableCategories,
            where: 'name = ?',
            whereArgs: [name],
            limit: 1,
          ))
          .isNotEmpty) {
        return const Error('Category name already exists');
      }
      final model = CategoryModel(name: name, icon: data.icon, color: data.color);
      final id = await _db.insertCategory(model.toDb());
      return Success(CategoryModel(id: id, name: name, icon: data.icon, color: data.color));
    } catch (e) {
      return Error(e.toString());
    }
  }
}


