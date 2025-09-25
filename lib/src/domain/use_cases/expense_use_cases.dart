import '../../core/base/result.dart';
import '../entities/expense_entity.dart';
import '../repositories/expense_repository.dart';

class GetExpensesUseCase {
  GetExpensesUseCase(this.repository);
  final ExpenseRepository repository;
  Future<List<ExpenseEntity>> call() => repository.getAll();
}

class GetFilteredExpensesUseCase {
  GetFilteredExpensesUseCase(this.repository);
  final ExpenseRepository repository;
  Future<List<ExpenseEntity>> call({
    int? limit,
    int? offset,
    int? categoryId,
    int? dateFromMs,
    int? dateToMs,
    String? search,
  }) async {
    if (repository is dynamic && (repository as dynamic).getFiltered != null) {
      return await (repository as dynamic).getFiltered(
        limit: limit,
        offset: offset,
        categoryId: categoryId,
        dateFromMs: dateFromMs,
        dateToMs: dateToMs,
        search: search,
      );
    }
    return repository.getAll();
  }
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

class UpdateExpenseUseCase {
  UpdateExpenseUseCase(this.repository);
  final ExpenseRepository repository;
  Future<Result<ExpenseEntity, String>> call(ExpenseEntity data) => repository.update(data);
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





