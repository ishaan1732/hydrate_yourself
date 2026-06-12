import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/double_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../home/presentation/home_provider.dart';
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
    final summaryAsync = ref.watch(analyticsSummaryProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: summaryAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (summary) {
            if (summary.totalMl30Days == 0) {
              return Center(
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
                      'No data yet',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Log water for a few days to\nsee your analytics',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }
            return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: colorScheme.surface,
                title: Text(
                  'Analytics',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: Text(
                    'Last 30 days',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
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
                                    ? summary.averageDailyMl.toWholeOzString()
                                    : summary.averageDailyMl.toHydrationString('ml'),
                                subtitle: 'per day',
                                icon: Icons.water_drop_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: StatCard(
                                label: 'Best Day',
                                value: unit == 'oz'
                                    ? summary.bestDayMl.toWholeOzString()
                                    : summary.bestDayMl.toHydrationString('ml'),
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
                                value: '${summary.daysGoalMet}/30',
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
                                    ? summary.totalMl30Days.toWholeOzString()
                                    : summary.totalMl30Days.toHydrationString('ml'),
                                subtitle: '30 day total',
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

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '30-Day Trend',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Daily intake vs goal (dashed)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 16),
                      TrendChart(points: summary.dailyChartPoints, unit: unit),
                    ],
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'By Drink Type',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'What you\'ve been drinking',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
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
          );
          },
        ),
      ),
    );
  }
}
