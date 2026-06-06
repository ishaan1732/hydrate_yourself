import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../database/database_provider.dart';
import '../../home/domain/water_log_model.dart';
import '../data/history_repository.dart';
import '../domain/daily_summary.dart';

part 'history_provider.g.dart';

@riverpod
HistoryRepository historyRepository(Ref ref) => HistoryRepository(
      ref.watch(waterLogsDaoProvider),
      ref.watch(drinkTypesDaoProvider),
      ref.watch(userProfileDaoProvider),
    );

@riverpod
Future<List<DailySummary>> weeklySummaries(Ref ref) =>
    ref.watch(historyRepositoryProvider).getWeeklySummaries();

@riverpod
Future<int> currentStreak(Ref ref) =>
    ref.watch(historyRepositoryProvider).calculateCurrentStreak();

final selectedDateProvider = StateProvider<DateTime?>((ref) => null);

@riverpod
Future<List<WaterLogModel>> selectedDateLogs(Ref ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  if (selectedDate == null) return Future.value([]);
  return ref.watch(historyRepositoryProvider).getLogsForDate(selectedDate);
}
