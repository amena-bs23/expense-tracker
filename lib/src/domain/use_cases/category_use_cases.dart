import '../../core/base/result.dart';
import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  GetCategoriesUseCase(this.repository);
  final CategoryRepository repository;
  Future<List<CategoryEntity>> call() => repository.getAll();
}

class CreateCategoryUseCase {
  CreateCategoryUseCase(this.repository);
  final CategoryRepository repository;
  Future<Result<CategoryEntity, String>> call(CategoryEntity data) =>
      repository.create(data);
}

class UpdateCategoryUseCase {
  UpdateCategoryUseCase(this.repository);
  final CategoryRepository repository;
  Future<Result<CategoryEntity, String>> call(CategoryEntity data) =>
      repository.update(data);
}

class DeleteCategoryUseCase {
  DeleteCategoryUseCase(this.repository);
  final CategoryRepository repository;
  Future<Result<void, String>> call(int id) => repository.delete(id);
}

class BackupCategoriesUseCase {
  BackupCategoriesUseCase(this.repository);
  final CategoryRepository repository;
  Future<List<CategoryEntity>> call() => repository.backup();
}

class RestoreCategoriesUseCase {
  RestoreCategoriesUseCase(this.repository);
  final CategoryRepository repository;
  Future<void> call(List<CategoryEntity> items) => repository.restore(items);
}

