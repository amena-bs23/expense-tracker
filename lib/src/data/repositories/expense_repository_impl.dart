import '../../core/base/result.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/expense_repository.dart';
import '../models/expense_model.dart';
import '../services/database/database_service.dart';

final class ExpenseRepositoryImpl extends ExpenseRepository {
  ExpenseRepositoryImpl(this._db);

  final DatabaseService _db;

  @override
  Future<List<ExpenseEntity>> getAll() async {
    final rows = await _db.getAllExpenses();
    return rows.map(ExpenseModel.fromDb).toList();
  }

  @override
  Future<Result<ExpenseEntity, String>> add(ExpenseEntity data) async {
    try {
      if (data.amount <= 0) return const Error('Amount must be positive');
      if (data.description.trim().isEmpty) return const Error('Description required');
      final model = ExpenseModel(
        amount: data.amount,
        description: data.description.trim(),
        categoryId: data.categoryId,
        dateMs: data.dateMs,
      );
      final id = await _db.insertExpense(model.toDb());
      return Success(ExpenseModel(
        id: id,
        amount: model.amount,
        description: model.description,
        categoryId: model.categoryId,
        dateMs: model.dateMs,
      ));
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<Result<void, String>> delete(int id) async {
    try {
      await _db.deleteExpense(id);
      return const Success(null);
    } catch (e) {
      return Error(e.toString());
    }
  }

  @override
  Future<List<ExpenseEntity>> backup() async {
    return getAll();
  }

  @override
  Future<void> restore(List<ExpenseEntity> items) async {
    for (final e in items) {
      try {
        await _db.insertExpense(ExpenseModel(
          amount: e.amount,
          description: e.description,
          categoryId: e.categoryId,
          dateMs: e.dateMs,
        ).toDb());
      } catch (_) {}
    }
  }
}




