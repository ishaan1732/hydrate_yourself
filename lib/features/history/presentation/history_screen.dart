import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/extensions/datetime_extensions.dart';
import '../../home/domain/water_log_model.dart';
import 'history_provider.dart';
import 'widgets/log_list_tile.dart';
import 'widgets/weekly_bar_chart.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final weeklySummariesAsync = ref.watch(weeklySummariesProvider);
    final streakAsync = ref.watch(currentStreakProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedLogsAsync = ref.watch(selectedDateLogsProvider);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: colorScheme.surface,
              title: Text(
                'History',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              actions: [
                streakAsync.when(
                  data: (streak) => streak > 0
                      ? Chip(
                          avatar: const Icon(
                            Icons.local_fire_department,
                            color: Colors.orange,
                            size: 16,
                          ),
                          label: Text('$streak day streak'),
                          backgroundColor:
                              Colors.orange.withValues(alpha: 0.1),
                        )
                      : const SizedBox(),
                  loading: () => const SizedBox(),
                  error: (_, _) => const SizedBox(),
                ),
                const SizedBox(width: 8),
              ],
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last 7 Days',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    weeklySummariesAsync.when(
                      loading: () => const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => Text('Error: $e'),
                      data: (summaries) => WeeklyBarChart(
                        summaries: summaries,
                        selectedDate: selectedDate,
                        onDayTapped: (date) {
                          final current = ref.read(selectedDateProvider);
                          if (current != null && current.isSameDay(date)) {
                            ref.read(selectedDateProvider.notifier).state =
                                null;
                          } else {
                            ref.read(selectedDateProvider.notifier).state =
                                date;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (selectedDate != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Text(
                        _formatSelectedDate(selectedDate),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      selectedLogsAsync.when(
                        data: (logs) => Text(
                          '${logs.length} logs · ${_totalForLogs(logs).round()}ml',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        loading: () => const SizedBox(),
                        error: (_, _) => const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ),

            if (selectedDate != null)
              selectedLogsAsync.when(
                loading: () => const SliverToBoxAdapter(
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) =>
                    SliverToBoxAdapter(child: Text('Error: $e')),
                data: (logs) => logs.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Center(
                            child: Text(
                              'No logs for this day',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: colorScheme.onSurfaceVariant),
                            ),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              LogListTile(log: logs[index]),
                          childCount: logs.length,
                        ),
                      ),
              ),

            if (selectedDate == null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.touch_app_outlined,
                          size: 32,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tap a bar to see that day\'s logs',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatSelectedDate(DateTime date) {
    final now = DateTime.now();
    if (date.isSameDay(now)) return 'Today';
    if (date.isSameDay(now.subtract(const Duration(days: 1)))) {
      return 'Yesterday';
    }
    return '${date.weekdayShort}, ${date.day} ${_monthName(date.month)}';
  }

  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return months[month - 1];
  }

  double _totalForLogs(List<WaterLogModel> logs) =>
      logs.fold(0.0, (sum, log) => sum + log.amountMl);
}
