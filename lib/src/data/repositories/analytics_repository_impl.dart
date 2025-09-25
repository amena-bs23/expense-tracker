import '../../domain/entities/expense_entity.dart';
import '../../domain/repositories/analytics_repository.dart';
import '../services/database/database_service.dart';
import '../models/expense_model.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(this._db);

  final DatabaseService _db;

  @override
  Future<double> totalForRange({required int fromMs, required int toMs}) async {
    final rows = await _db.getExpenses(dateFromMs: fromMs, dateToMs: toMs);
    return rows.map(ExpenseModel.fromDb).fold<double>(0.0, (s, e) => s + e.amount);
  }

  @override
  Future<Map<int, double>> breakdownByCategory({required int fromMs, required int toMs}) async {
    final rows = await _db.getExpenses(dateFromMs: fromMs, dateToMs: toMs);
    final map = <int, double>{};
    for (final e in rows.map(ExpenseModel.fromDb)) {
      map.update(e.categoryId, (v) => v + e.amount, ifAbsent: () => e.amount);
    }
    return map;
  }

  @override
  Future<List<MapEntry<int, double>>> topCategories({required int fromMs, required int toMs, int limit = 5}) async {
    final b = await breakdownByCategory(fromMs: fromMs, toMs: toMs);
    final entries = b.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    if (entries.length > limit) return entries.sublist(0, limit);
    return entries;
  }

  @override
  Future<List<MapEntry<int, double>>> dailyTrends({required int fromMs, required int toMs}) async {
    final rows = await _db.getExpenses(dateFromMs: fromMs, dateToMs: toMs);
    final map = <int, double>{};
    for (final e in rows.map(ExpenseModel.fromDb)) {
      final day = DateTime.fromMillisecondsSinceEpoch(e.dateMs);
      final dayKey = DateTime(day.year, day.month, day.day).millisecondsSinceEpoch;
      map.update(dayKey, (v) => v + e.amount, ifAbsent: () => e.amount);
    }
    final entries = map.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return entries;
  }

  @override
  Future<({double daily, double weekly, double monthly})> averages() async {
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month, 1);
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final rows = await _db.getExpenses(dateFromMs: monthStart.millisecondsSinceEpoch, dateToMs: now.millisecondsSinceEpoch);
    final list = rows.map(ExpenseModel.fromDb).toList();
    final total = list.fold<double>(0.0, (s, e) => s + e.amount);
    final daysElapsed = now.difference(monthStart).inDays + 1;
    final dailyAvg = daysElapsed > 0 ? total / daysElapsed : 0.0;
    final weekTotal = list
        .where((e) => e.dateMs >= weekStart.millisecondsSinceEpoch)
        .fold<double>(0.0, (s, e) => s + e.amount);
    final weeklyAvg = weekTotal; // per week
    final monthlyAvg = total; // per month
    return (daily: dailyAvg, weekly: weeklyAvg, monthly: monthlyAvg);
  }

  @override
  Future<List<ExpenseEntity>> rawForRange({required int fromMs, required int toMs}) async {
    final rows = await _db.getExpenses(dateFromMs: fromMs, dateToMs: toMs);
    return rows.map(ExpenseModel.fromDb).toList();
  }
}



