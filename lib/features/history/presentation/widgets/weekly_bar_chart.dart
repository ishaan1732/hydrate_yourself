import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/datetime_extensions.dart';
import '../../../../core/extensions/double_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/daily_summary.dart';

class WeeklyBarChart extends StatelessWidget {
  const WeeklyBarChart({
    super.key,
    required this.summaries,
    required this.selectedDate,
    required this.onDayTapped,
    this.unit = 'ml',
  });

  final List<DailySummary> summaries;
  final DateTime? selectedDate;
  final void Function(DateTime) onDayTapped;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          maxY: _getMaxY(summaries),
          minY: 0,
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
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= summaries.length) {
                    return const SizedBox();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      summaries[index].date.weekdayShort,
                      style: theme.textTheme.labelSmall,
                    ),
                  );
                },
              ),
            ),
          ),
          barTouchData: BarTouchData(
            touchCallback: (event, response) {
              if (event is FlTapUpEvent && response?.spot != null) {
                final index = response!.spot!.touchedBarGroupIndex;
                if (index >= 0 && index < summaries.length) {
                  onDayTapped(summaries[index].date);
                }
              }
            },
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final summary = summaries[groupIndex];
                return BarTooltipItem(
                  summary.totalMl.toHydrationString(unit),
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            ),
          ),
          barGroups: summaries.asMap().entries.map((entry) {
            final index = entry.key;
            final summary = entry.value;
            final isSelected = selectedDate != null &&
                summary.date.isSameDay(selectedDate!);
            final isToday = summary.date.isSameDay(DateTime.now());

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: summary.totalMl,
                  width: 28,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(6)),
                  color: isSelected
                      ? colorScheme.primary
                      : summary.goalAchieved
                          ? AppColors.goalAchieved.withValues(alpha: 0.8)
                          : isToday
                              ? colorScheme.primary.withValues(alpha: 0.6)
                              : colorScheme.surfaceContainerHighest,
                  rodStackItems: [],
                ),
              ],
              showingTooltipIndicators: isSelected ? [0] : [],
            );
          }).toList(),
          extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: summaries.isNotEmpty
                    ? summaries.first.goalMl.toDouble()
                    : 2500,
                color: colorScheme.outline.withValues(alpha: 0.5),
                strokeWidth: 1.5,
                dashArray: [6, 4],
                label: HorizontalLineLabel(
                  show: true,
                  alignment: Alignment.topRight,
                  labelResolver: (_) => 'Goal',
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.outline,
                  ),
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ),
    );
  }

  double _getMaxY(List<DailySummary> summaries) {
    if (summaries.isEmpty) return 3000;
    final maxTotal = summaries.map((s) => s.totalMl).reduce(max);
    final goalMl = summaries.first.goalMl.toDouble();
    return (max(maxTotal, goalMl) * 1.2).ceilToDouble();
  }
}
