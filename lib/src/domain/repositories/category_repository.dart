import '../../core/base/repository.dart';
import '../../core/base/result.dart';
import '../entities/category_entity.dart';

abstract base class CategoryRepository extends Repository {
  Future<List<CategoryEntity>> getAll();
  Future<Result<CategoryEntity, String>> create(CategoryEntity data);
  Future<Result<CategoryEntity, String>> update(CategoryEntity data);
  Future<Result<void, String>> delete(int id);
  Future<void> preloadDefaultsIfEmpty();
  Future<List<CategoryEntity>> backup();
  Future<void> restore(List<CategoryEntity> items);
}


