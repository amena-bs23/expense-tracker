import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/expense_entity.dart';

abstract base class ExpenseRepository extends Repository {
  Future<List<ExpenseEntity>> getAll();
  Future<Result<ExpenseEntity, String>> add(ExpenseEntity data);
  Future<Result<ExpenseEntity, String>> update(ExpenseEntity data);
  Future<Result<void, String>> delete(int id);
  Future<List<ExpenseEntity>> backup();
  Future<void> restore(List<ExpenseEntity> items);
}





