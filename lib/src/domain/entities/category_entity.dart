class CategoryEntity {
  const CategoryEntity({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  final int? id;
  final String name;
  final String icon; // material icon name string
  final int color; // ARGB hex int
}

