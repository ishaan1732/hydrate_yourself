import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../domain/analytics_models.dart';

class TrendChart extends StatelessWidget {
  const TrendChart({super.key, required this.points, this.unit = 'ml'});

  final List<DailyChartPoint> points;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final allZero = points.every((p) => p.totalMl == 0.0);
    if (allZero) {
      return SizedBox(
        height: 160,
        child: Center(
          child: Text(
            'Start tracking to see trends',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ),
      );
    }

    final maxY = points
            .map((p) => max(p.totalMl, p.goalMl.toDouble()))
            .reduce(max) *
        1.2;

    return SizedBox(
      height: 160,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 7,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= points.length) {
                    return const SizedBox();
                  }
                  if (index % 7 != 0) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${points[index].date.day}/${points[index].date.month}',
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),
          ),
          minY: 0,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: points
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value.totalMl))
                  .toList(),
              isCurved: true,
              curveSmoothness: 0.3,
              color: colorScheme.primary,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: colorScheme.primary.withValues(alpha: 0.08),
              ),
            ),
            LineChartBarData(
              spots: points
                  .asMap()
                  .entries
                  .map((e) =>
                      FlSpot(e.key.toDouble(), e.value.goalMl.toDouble()))
                  .toList(),
              isCurved: false,
              color: colorScheme.outline.withValues(alpha: 0.5),
              barWidth: 1.5,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              dashArray: [6, 4],
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }
}
