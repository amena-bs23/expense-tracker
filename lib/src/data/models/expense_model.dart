import '../../domain/entities/expense_entity.dart';

class ExpenseModel extends ExpenseEntity {
  const ExpenseModel({
    super.id,
    required super.amount,
    required super.description,
    required super.categoryId,
    required super.dateMs,
  });

  Map<String, Object?> toDb() => {
    'id': id,
    'amount': amount,
    'description': description,
    'category_id': categoryId,
    'date_ms': dateMs,
  }..removeWhere((k, v) => v == null);

  static ExpenseModel fromDb(Map<String, Object?> row) => ExpenseModel(
    id: row['id'] as int?,
    amount: (row['amount'] as num).toDouble(),
    description: row['description'] as String,
    categoryId: row['category_id'] as int,
    dateMs: row['date_ms'] as int,
  );
}

