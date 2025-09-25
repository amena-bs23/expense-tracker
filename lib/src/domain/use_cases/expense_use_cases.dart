import '../../core/base/result.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class GetExpensesUseCase {
  GetExpensesUseCase(this.repository);
  final ExpenseRepository repository;
  Future<List<ExpenseEntity>> call() => repository.getAll();
}

class AddExpenseUseCase {
  AddExpenseUseCase(this.repository);
  final ExpenseRepository repository;
  Future<Result<ExpenseEntity, String>> call(ExpenseEntity data) => repository.add(data);
}

class DeleteExpenseUseCase {
  DeleteExpenseUseCase(this.repository);
  final ExpenseRepository repository;
  Future<Result<void, String>> call(int id) => repository.delete(id);
}

class BackupExpensesUseCase {
  BackupExpensesUseCase(this.repository);
  final ExpenseRepository repository;
  Future<List<ExpenseEntity>> call() => repository.backup();
}

class RestoreExpensesUseCase {
  RestoreExpensesUseCase(this.repository);
  final ExpenseRepository repository;
  Future<void> call(List<ExpenseEntity> items) => repository.restore(items);
}




