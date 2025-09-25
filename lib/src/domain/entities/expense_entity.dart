class ExpenseEntity {
  const ExpenseEntity({
    this.id,
    required this.amount,
    required this.description,
    required this.categoryId,
    required this.dateMs,
  });

  final int? id;
  final double amount;
  final String description;
  final int categoryId;
  final int dateMs;
}
