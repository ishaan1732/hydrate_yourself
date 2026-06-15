import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/double_extensions.dart';
import '../../../../core/utils/color_utils.dart';

class DrinkBreakdownChart extends StatelessWidget {
  const DrinkBreakdownChart({
    super.key,
    required this.drinkTypeTotals,
    required this.drinkTypeColors,
    this.unit = 'ml',
  });

  final Map<String, double> drinkTypeTotals;
  final Map<String, String> drinkTypeColors;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (drinkTypeTotals.isEmpty) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text(
            'No data yet',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final total = drinkTypeTotals.values.reduce((a, b) => a + b);
    final showSliceLabels = drinkTypeTotals.length <= 4;

    return Row(
      children: [
        Expanded(
          flex: 1,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 35,
              sections: drinkTypeTotals.entries.map((entry) {
                final percentage = entry.value / total * 100;
                return PieChartSectionData(
                  value: entry.value,
                  title: showSliceLabels ? '${percentage.round()}%' : '',
                  titleStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  radius: 55,
                  color: hexToColor(
                      drinkTypeColors[entry.key] ?? '#9E9E9E'),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: drinkTypeTotals.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: hexToColor(
                              drinkTypeColors[entry.key] ?? '#9E9E9E'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          entry.key,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: theme.textTheme.labelMedium,
                        ),
                      ),
                      Text(
                        unit == 'oz'
                            ? entry.value.toHalfOzString()
                            : entry.value.toMlAmountString(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

}
