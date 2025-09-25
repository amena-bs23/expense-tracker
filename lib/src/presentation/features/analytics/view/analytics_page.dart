import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../riverpod/analytics_provider.dart';

class AnalyticsPage extends ConsumerWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analyticsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () async {
                    final now = DateTime.now();
                    final from = await showDatePicker(
                      context: context,
                      firstDate: DateTime(now.year - 5),
                      lastDate: now,
                      initialDate: DateTime(now.year, now.month, 1),
                    );
                    if (from == null) return;
                    final to = await showDatePicker(
                      context: context,
                      firstDate: from,
                      lastDate: DateTime(now.year + 5),
                      initialDate: from,
                    );
                    if (to == null) return;
                    await ref.read(analyticsProvider.notifier).load(
                          DateTime(from.year, from.month, from.day).millisecondsSinceEpoch,
                          DateTime(to.year, to.month, to.day, 23, 59, 59).millisecondsSinceEpoch,
                        );
                  },
                  icon: const Icon(Icons.date_range),
                  label: const Text('Date range'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _metricCard('Total (range)', state.total.toStringAsFixed(2))),
              const SizedBox(width: 12),
              Expanded(child: _metricCard('Avg/day', state.dailyAvg.toStringAsFixed(2))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _metricCard('Avg/week', state.weeklyAvg.toStringAsFixed(2))),
              const SizedBox(width: 12),
              Expanded(child: _metricCard('Avg/month', state.monthlyAvg.toStringAsFixed(2))),
            ],
          ),
          const SizedBox(height: 16),
          Text('Category Breakdown', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(height: 220, child: _pieChart(state, context)),
          const SizedBox(height: 16),
          Text('Daily Trends', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SizedBox(height: 220, child: _lineChart(state, context)),
        ],
      ),
    );
  }

  Widget _metricCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _pieChart(AnalyticsState state, BuildContext context) {
    final sections = <PieChartSectionData>[];
    final total = state.breakdown.values.fold(0.0, (s, v) => s + v);
    if (total == 0) {
      return const Center(child: Text('No data'));
    }
    int idx = 0;
    for (final e in state.breakdown.entries) {
      final percent = (e.value / total) * 100;
      sections.add(PieChartSectionData(
        color: Colors.primaries[idx % Colors.primaries.length],
        value: e.value,
        title: '${percent.toStringAsFixed(1)}%',
        radius: 60,
      ));
      idx++;
    }
    return PieChart(
      PieChartData(
        sections: sections,
        sectionsSpace: 2,
        pieTouchData: PieTouchData(touchCallback: (event, resp) {
          if (resp?.touchedSection == null) return;
          final i = resp!.touchedSection!.touchedSectionIndex;
          final entry = state.breakdown.entries.elementAt(i);
          final value = entry.value;
          final total = state.breakdown.values.fold(0.0, (s, v) => s + v);
          final percent = (value / total) * 100;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Category ${entry.key}: ${value.toStringAsFixed(2)} (${percent.toStringAsFixed(1)}%)')),
          );
        }),
      ),
    );
  }

  Widget _lineChart(AnalyticsState state, BuildContext context) {
    if (state.trends.isEmpty) return const Center(child: Text('No data'));
    final spots = <FlSpot>[];
    final minX = state.trends.first.key.toDouble();
    for (final e in state.trends) {
      spots.add(FlSpot((e.key - minX) / 86400000, e.value));
    }
    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(spots: spots, isCurved: true, color: Colors.blue, dotData: const FlDotData(show: false)),
        ],
        lineTouchData: LineTouchData(touchCallback: (event, resp) {
          if (resp == null || resp.lineBarSpots == null || resp.lineBarSpots!.isEmpty) return;
          final s = resp.lineBarSpots!.first;
          final dayMs = state.trends.first.key + (s.x * 86400000).toInt();
          final date = DateTime.fromMillisecondsSinceEpoch(dayMs);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${date.toLocal().toString().split(' ').first}: ${s.y.toStringAsFixed(2)}')),
          );
        }),
      ),
    );
  }
}


