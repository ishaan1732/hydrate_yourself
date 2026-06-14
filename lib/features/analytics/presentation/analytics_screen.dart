import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/double_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/presentation/home_provider.dart';
import '../domain/analytics_period.dart';
import 'analytics_provider.dart';
import 'widgets/drink_breakdown_chart.dart';
import 'widgets/stat_card.dart';
import 'widgets/trend_chart.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final unit = ref.watch(appUnitProvider).valueOrNull ?? AppConstants.unitMl;
    final selectedPeriod = ref.watch(selectedAnalyticsPeriodProvider);
    final summaryAsync = ref.watch(analyticsSummaryProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: summaryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (summary) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: colorScheme.surface,
                  title: Text(
                    'Analytics',
                    style:
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                  ),
                ),

                // Period chip selector — always visible
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 4),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: AnalyticsPeriod.values.map((p) {
                          final isSelected = selectedPeriod == p;
                          return GestureDetector(
                            onTap: () => ref
                                .read(selectedAnalyticsPeriodProvider
                                    .notifier)
                                .setPeriod(p),
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: isSelected
                                    ? colorScheme.primaryContainer
                                    : colorScheme.surface,
                                border: Border.all(
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.outline
                                          .withValues(alpha: 0.3),
                                  width: isSelected ? 1.5 : 0.5,
                                ),
                              ),
                              child: Text(
                                p.label,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isSelected
                                      ? FontWeight.w500
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? colorScheme.primary
                                      : colorScheme.onSurface,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),

                // Empty state for selected period
                if (summary.totalMl == 0)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.insights_outlined,
                            size: 64,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            selectedPeriod == AnalyticsPeriod.allTime
                                ? 'No data yet'
                                : 'No data for this period',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Log water to see your analytics',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                    color: colorScheme.onSurfaceVariant),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  // Stat cards
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        children: [
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: StatCard(
                                    label: 'Daily Average',
                                    value: unit == 'oz'
                                        ? summary.averageDailyMl
                                            .toWholeOzString()
                                        : summary.averageDailyMl
                                            .toHydrationString('ml'),
                                    subtitle: 'per day',
                                    icon: Icons.water_drop_outlined,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: StatCard(
                                    label: 'Best Day',
                                    value: unit == 'oz'
                                        ? summary.bestDayMl
                                            .toWholeOzString()
                                        : summary.bestDayMl
                                            .toHydrationString('ml'),
                                    subtitle: 'single day',
                                    icon: Icons.emoji_events_outlined,
                                    iconColor: AppColors.goalWarning,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: StatCard(
                                    label: 'Goal Days',
                                    value:
                                        '${summary.daysGoalMet}/${summary.daysInPeriod}',
                                    subtitle: 'days goal met',
                                    icon: Icons.check_circle_outline,
                                    iconColor: AppColors.goalAchieved,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: StatCard(
                                    label: 'Total Intake',
                                    value: unit == 'oz'
                                        ? summary.totalMl
                                            .toWholeOzString()
                                        : summary.totalMl
                                            .toHydrationString('ml'),
                                    subtitle:
                                        '${selectedPeriod.label} total',
                                    icon: Icons.summarize_outlined,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Trend chart
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Trend — ${selectedPeriod.label}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Water intake',
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 16),
                          TrendChart(
                            points: summary.chartPoints,
                            period: selectedPeriod,
                            goalMl: summary.goalMl,
                            unit: unit,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Drink breakdown
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'By Drink Type',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "What you've been drinking",
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color: colorScheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 160,
                            child: DrinkBreakdownChart(
                              drinkTypeTotals: summary.drinkTypeTotals,
                              drinkTypeColors: summary.drinkTypeColors,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
