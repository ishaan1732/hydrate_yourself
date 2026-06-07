import 'dart:math';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/datetime_extensions.dart';
import '../../../database/daos/drink_types_dao.dart';
import '../../../database/daos/user_profile_dao.dart';
import '../../../database/daos/water_logs_dao.dart';
import '../domain/analytics_models.dart';

class AnalyticsRepository {
  AnalyticsRepository(
    this._waterLogsDao,
    this._drinkTypesDao,
    this._userProfileDao,
  );

  final WaterLogsDao _waterLogsDao;
  final DrinkTypesDao _drinkTypesDao;
  final UserProfileDao _userProfileDao;

  Future<AnalyticsSummary> getAnalyticsSummary() async {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 29));

    final logs = await _waterLogsDao.getLogsForDateRange(start, end);
    final profile = await _userProfileDao.getProfile();
    final allDrinkTypes = await _drinkTypesDao.getAllDrinkTypes();

    final goalMl = profile?.dailyGoalMl ?? AppConstants.defaultDailyGoalMl;

    final dailyTotals = <DateTime, double>{};
    for (final log in logs) {
      final date = log.loggedAt.dateOnly;
      dailyTotals[date] = (dailyTotals[date] ?? 0) + log.amountMl;
    }

    final averageDailyMl = dailyTotals.values.isEmpty
        ? 0.0
        : dailyTotals.values.reduce((a, b) => a + b) / 30;

    final bestDayMl = dailyTotals.values.isEmpty
        ? 0.0
        : dailyTotals.values.reduce(max);

    final daysGoalMet =
        dailyTotals.values.where((v) => v >= goalMl).length;

    final totalMl30Days =
        logs.fold(0.0, (sum, log) => sum + log.amountMl);

    final drinkTypeTotals = <String, double>{};
    for (final log in logs) {
      final drinkType = allDrinkTypes.firstWhere(
        (dt) => dt.id == log.drinkTypeId,
        orElse: () => allDrinkTypes.first,
      );
      drinkTypeTotals[drinkType.name] =
          (drinkTypeTotals[drinkType.name] ?? 0) + log.amountMl;
    }

    final dailyChartPoints = <DailyChartPoint>[];
    for (var i = 0; i < 30; i++) {
      final date = DateTime(end.year, end.month, end.day)
          .subtract(Duration(days: 29 - i));
      dailyChartPoints.add(DailyChartPoint(
        date: date,
        totalMl: dailyTotals[date] ?? 0.0,
        goalMl: goalMl,
      ));
    }

    return AnalyticsSummary(
      averageDailyMl: averageDailyMl,
      bestDayMl: bestDayMl,
      daysGoalMet: daysGoalMet,
      totalMl30Days: totalMl30Days,
      goalMl: goalMl,
      drinkTypeTotals: drinkTypeTotals,
      dailyChartPoints: dailyChartPoints,
    );
  }
}
