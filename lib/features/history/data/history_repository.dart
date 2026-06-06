import 'package:hydrate_yourself/database/app_database.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/datetime_extensions.dart';
import '../../../database/daos/drink_types_dao.dart';
import '../../../database/daos/user_profile_dao.dart';
import '../../../database/daos/water_logs_dao.dart';
import '../../home/domain/water_log_model.dart';
import '../domain/daily_summary.dart';

class HistoryRepository {
  HistoryRepository(
    this._waterLogsDao,
    this._drinkTypesDao,
    this._userProfileDao,
  );

  final WaterLogsDao _waterLogsDao;
  final DrinkTypesDao _drinkTypesDao;
  final UserProfileDao _userProfileDao;

  Future<List<DailySummary>> getWeeklySummaries() async {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 6));

    final logs = await _waterLogsDao.getLogsForDateRange(start, end);
    final allDrinkTypes = await _drinkTypesDao.getAllDrinkTypes();
    final profile = await _userProfileDao.getProfile();
    final goalMl = profile?.dailyGoalMl ?? AppConstants.defaultDailyGoalMl;

    final logsByDate = <DateTime, List<WaterLogsData>>{};
    for (final log in logs) {
      final date = log.loggedAt.dateOnly;
      logsByDate[date] ??= [];
      logsByDate[date]!.add(log);
    }

    final summaries = <DailySummary>[];
    for (var i = 0; i < 7; i++) {
      final date = DateTime(end.year, end.month, end.day)
          .subtract(Duration(days: 6 - i));
      final dayLogs = logsByDate[date] ?? [];
      final totalMl = dayLogs.fold(0.0, (sum, log) => sum + log.amountMl);

      final waterLogModels = dayLogs.map((log) {
        final drinkType = allDrinkTypes.firstWhere(
          (dt) => dt.id == log.drinkTypeId,
          orElse: () => allDrinkTypes.first,
        );
        return WaterLogModel.fromDrift(log, drinkType);
      }).toList();

      summaries.add(DailySummary(
        date: date,
        totalMl: totalMl,
        goalMl: goalMl,
        logs: waterLogModels,
      ));
    }

    return summaries;
  }

  Future<int> calculateCurrentStreak() async {
    final now = DateTime.now();
    final logs = await _waterLogsDao.getLogsForDateRange(
      now.subtract(const Duration(days: 90)),
      now,
    );
    final profile = await _userProfileDao.getProfile();
    final goalMl = profile?.dailyGoalMl ?? AppConstants.defaultDailyGoalMl;

    final totalsByDate = <DateTime, double>{};
    for (final log in logs) {
      final date = log.loggedAt.dateOnly;
      totalsByDate[date] = (totalsByDate[date] ?? 0.0) + log.amountMl;
    }

    var streak = 0;
    for (var i = 1; i <= 90; i++) {
      final date = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: i));
      final total = totalsByDate[date] ?? 0.0;
      if (total >= goalMl) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  Future<List<WaterLogModel>> getLogsForDate(DateTime date) async {
    final start = date.dateOnly;
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final logs = await _waterLogsDao.getLogsForDateRange(start, end);
    final allDrinkTypes = await _drinkTypesDao.getAllDrinkTypes();

    return logs
        .map((log) {
          final drinkType = allDrinkTypes.firstWhere(
            (dt) => dt.id == log.drinkTypeId,
            orElse: () => allDrinkTypes.first,
          );
          return WaterLogModel.fromDrift(log, drinkType);
        })
        .toList()
      ..sort((a, b) => b.loggedAt.compareTo(a.loggedAt));
  }
}
