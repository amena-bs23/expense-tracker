import '../repositories/analytics_repository.dart';

class GetTotalsUseCase {
  GetTotalsUseCase(this.repository);
  final AnalyticsRepository repository;
  Future<double> call(int fromMs, int toMs) => repository.totalForRange(fromMs: fromMs, toMs: toMs);
}

class GetBreakdownUseCase {
  GetBreakdownUseCase(this.repository);
  final AnalyticsRepository repository;
  Future<Map<int, double>> call(int fromMs, int toMs) => repository.breakdownByCategory(fromMs: fromMs, toMs: toMs);
}

class GetTopCategoriesUseCase {
  GetTopCategoriesUseCase(this.repository);
  final AnalyticsRepository repository;
  Future<List<MapEntry<int, double>>> call(int fromMs, int toMs, {int limit = 5}) => repository.topCategories(fromMs: fromMs, toMs: toMs, limit: limit);
}

class GetDailyTrendsUseCase {
  GetDailyTrendsUseCase(this.repository);
  final AnalyticsRepository repository;
  Future<List<MapEntry<int, double>>> call(int fromMs, int toMs) => repository.dailyTrends(fromMs: fromMs, toMs: toMs);
}

class GetAveragesUseCase {
  GetAveragesUseCase(this.repository);
  final AnalyticsRepository repository;
  Future<({double daily, double weekly, double monthly})> call() => repository.averages();
}




