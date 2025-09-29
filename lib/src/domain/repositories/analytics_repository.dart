import '../entities/expense_entity.dart';

abstract class AnalyticsRepository {
  Future<double> totalForRange({required int fromMs, required int toMs});
  Future<Map<int, double>> breakdownByCategory({required int fromMs, required int toMs});
  Future<List<MapEntry<int, double>>> topCategories({required int fromMs, required int toMs, int limit});
  Future<List<MapEntry<int, double>>> dailyTrends({required int fromMs, required int toMs});
  Future<({double daily, double weekly, double monthly})> averages();
  Future<List<ExpenseEntity>> rawForRange({required int fromMs, required int toMs});
}




