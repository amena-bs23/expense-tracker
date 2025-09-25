import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/dependency_injection.dart';

part 'analytics_provider.g.dart';

class AnalyticsState {
  const AnalyticsState({
    this.total = 0,
    this.breakdown = const {},
    this.trends = const [],
    this.top = const [],
    this.dailyAvg = 0,
    this.weeklyAvg = 0,
    this.monthlyAvg = 0,
    this.fromMs,
    this.toMs,
  });

  final double total;
  final Map<int, double> breakdown;
  final List<MapEntry<int, double>> trends;
  final List<MapEntry<int, double>> top;
  final double dailyAvg;
  final double weeklyAvg;
  final double monthlyAvg;
  final int? fromMs;
  final int? toMs;

  AnalyticsState copyWith({
    double? total,
    Map<int, double>? breakdown,
    List<MapEntry<int, double>>? trends,
    List<MapEntry<int, double>>? top,
    double? dailyAvg,
    double? weeklyAvg,
    double? monthlyAvg,
    int? fromMs,
    int? toMs,
  }) => AnalyticsState(
        total: total ?? this.total,
        breakdown: breakdown ?? this.breakdown,
        trends: trends ?? this.trends,
        top: top ?? this.top,
        dailyAvg: dailyAvg ?? this.dailyAvg,
        weeklyAvg: weeklyAvg ?? this.weeklyAvg,
        monthlyAvg: monthlyAvg ?? this.monthlyAvg,
        fromMs: fromMs ?? this.fromMs,
        toMs: toMs ?? this.toMs,
      );
}

@riverpod
class Analytics extends _$Analytics {
  @override
  AnalyticsState build() {
    final now = DateTime.now();
    final from = DateTime(now.year, now.month, 1).millisecondsSinceEpoch;
    final to = now.millisecondsSinceEpoch;
    load(from, to);
    return AnalyticsState(fromMs: from, toMs: to);
  }

  Future<void> load(int fromMs, int toMs) async {
    final totals = await ref.read(getTotalsUseCaseProvider).call(fromMs, toMs);
    final breakdown = await ref.read(getBreakdownUseCaseProvider).call(fromMs, toMs);
    final trends = await ref.read(getDailyTrendsUseCaseProvider).call(fromMs, toMs);
    final top = await ref.read(getTopCategoriesUseCaseProvider).call(fromMs, toMs);
    final avg = await ref.read(getAveragesUseCaseProvider).call();
    state = state.copyWith(
      total: totals,
      breakdown: breakdown,
      trends: trends,
      top: top,
      dailyAvg: avg.daily,
      weeklyAvg: avg.weekly,
      monthlyAvg: avg.monthly,
      fromMs: fromMs,
      toMs: toMs,
    );
  }
}


