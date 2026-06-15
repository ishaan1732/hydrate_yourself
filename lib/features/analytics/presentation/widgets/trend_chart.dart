import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/double_extensions.dart';
import '../../domain/analytics_models.dart';
import '../../domain/analytics_period.dart';

class TrendChart extends StatelessWidget {
  const TrendChart({
    super.key,
    required this.points,
    required this.period,
    required this.goalMl,
    this.unit = 'ml',
  });

  final List<ChartDataPoint> points;
  final AnalyticsPeriod period;
  final int goalMl;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (points.isEmpty || points.every((p) => p.y == 0)) {
      return SizedBox(
        height: 180,
        child: Center(
          child: Text(
            'No data for this period',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ),
      );
    }

    final spots = points.map((p) => FlSpot(p.x, p.y)).toList();
    final dataMax =
        points.map((p) => p.y).reduce(max);
    final maxY = max(dataMax, goalMl.toDouble()) * 1.25;

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (points.length - 1).toDouble(),
          minY: 0,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (value) => FlLine(
              color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              strokeWidth: 1,
            ),
          ),
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
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= points.length) {
                    return const SizedBox.shrink();
                  }
                  final totalPoints = points.length;
                  // For short series show every label; for longer ones apply
                  // an interval so labels don't crowd. First and last always show.
                  if (totalPoints > 14) {
                    final interval =
                        totalPoints <= 30 ? 5 : 7;
                    final isFirst = index == 0;
                    final isLast = index == totalPoints - 1;
                    final isInterval = index % interval == 0;
                    if (!isFirst && !isLast && !isInterval) {
                      return const SizedBox.shrink();
                    }
                  }
                  final label = points[index].label;
                  if (label.isEmpty) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: goalMl.toDouble(),
                color: colorScheme.error.withValues(alpha: 0.6),
                strokeWidth: 1.5,
                dashArray: [6, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  labelResolver: (_) => 'Goal',
                  style: TextStyle(
                    fontSize: 9,
                    color: colorScheme.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (spot) => colorScheme.surfaceContainerHighest,
              getTooltipItems: (spots) => spots.map((s) {
                final tip = unit == 'oz'
                    ? s.y.toWholeOzString()
                    : s.y.toMlAmountString();
                return LineTooltipItem(
                  tip,
                  TextStyle(
                    fontSize: 12,
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: colorScheme.primary,
              barWidth: 2.5,
              dotData: FlDotData(
                show: period == AnalyticsPeriod.week,
              ),
              belowBarData: BarAreaData(
                show: true,
                color: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }
}
