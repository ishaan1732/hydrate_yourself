import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/double_extensions.dart';
import '../../../../core/theme/app_colors.dart';

class DrinkBreakdownChart extends StatelessWidget {
  const DrinkBreakdownChart({super.key, required this.drinkTypeTotals});

  final Map<String, double> drinkTypeTotals;

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
                  title: '${percentage.round()}%',
                  titleStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  radius: 55,
                  color: _colorForDrink(entry.key),
                );
              }).toList(),
            ),
          ),
        ),
        Expanded(
          flex: 1,
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
                        color: _colorForDrink(entry.key),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.key,
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                    Text(
                      entry.value.toHydrationString('ml'),
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
      ],
    );
  }

  Color _colorForDrink(String name) {
    return switch (name.toLowerCase()) {
      'water' => AppColors.primary,
      'coffee' => AppColors.coffee,
      'tea' => const Color(0xFF8D6E63),
      'juice' => AppColors.juice,
      'soda' => const Color(0xFF78909C),
      _ => const Color(0xFF9E9E9E),
    };
  }
}
