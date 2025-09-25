import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({super.id, required super.name, required super.icon, required super.color});

  Map<String, Object?> toDb() => {
        'id': id,
        'name': name,
        'icon': icon,
        'color': color,
      }..removeWhere((k, v) => v == null);

  static CategoryModel fromDb(Map<String, Object?> row) => CategoryModel(
        id: row['id'] as int?,
        name: row['name'] as String,
        icon: row['icon'] as String,
        color: row['color'] as int,
      );
}


