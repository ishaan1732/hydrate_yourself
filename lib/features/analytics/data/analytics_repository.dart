import 'dart:math';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/datetime_extensions.dart';
import '../../../database/daos/drink_types_dao.dart';
import '../../../database/daos/user_profile_dao.dart';
import '../../../database/daos/water_logs_dao.dart';
import '../domain/analytics_models.dart';
import '../domain/analytics_period.dart';

class AnalyticsRepository {
  AnalyticsRepository(
    this._waterLogsDao,
    this._drinkTypesDao,
    this._userProfileDao,
  );

  final WaterLogsDao _waterLogsDao;
  final DrinkTypesDao _drinkTypesDao;
  final UserProfileDao _userProfileDao;

  Future<AnalyticsSummary> getAnalyticsSummary(AnalyticsPeriod period) async {
    final end = DateTime.now();
    final start = period.startDate;

    final logs = await _waterLogsDao.getLogsForDateRange(start, end);
    final profile = await _userProfileDao.getProfile();
    final allDrinkTypes = await _drinkTypesDao.getAllDrinkTypes();

    final goalMl = profile?.dailyGoalMl ?? AppConstants.defaultDailyGoalMl;

    final dailyTotals = <DateTime, double>{};
    for (final log in logs) {
      final date = log.loggedAt.dateOnly;
      dailyTotals[date] = (dailyTotals[date] ?? 0) + log.amountMl;
    }

    final int daysInPeriod;
    if (period == AnalyticsPeriod.allTime) {
      daysInPeriod = max(dailyTotals.length, 1);
    } else {
      daysInPeriod = end.difference(start).inDays + 1;
    }

    final averageDailyMl = dailyTotals.values.isEmpty
        ? 0.0
        : dailyTotals.values.reduce((a, b) => a + b) / daysInPeriod;

    final bestDayMl =
        dailyTotals.values.isEmpty ? 0.0 : dailyTotals.values.reduce(max);

    final daysGoalMet =
        dailyTotals.values.where((v) => v >= goalMl).length;

    final totalMl = logs.fold(0.0, (sum, log) => sum + log.amountMl);

    final drinkTypeTotals = <String, double>{};
    final drinkTypeColors = <String, String>{};
    for (final log in logs) {
      final drinkType = allDrinkTypes.firstWhere(
        (dt) => dt.id == log.drinkTypeId,
        orElse: () => allDrinkTypes.first,
      );
      drinkTypeTotals[drinkType.name] =
          (drinkTypeTotals[drinkType.name] ?? 0) + log.amountMl;
      drinkTypeColors[drinkType.name] = drinkType.colorHex;
    }

    final chartBars = _buildChartBars(period, dailyTotals);

    return AnalyticsSummary(
      averageDailyMl: averageDailyMl,
      bestDayMl: bestDayMl,
      daysGoalMet: daysGoalMet,
      daysInPeriod: daysInPeriod,
      totalMl: totalMl,
      goalMl: goalMl,
      drinkTypeTotals: drinkTypeTotals,
      drinkTypeColors: drinkTypeColors,
      chartBars: chartBars,
    );
  }

  List<ChartBar> _buildChartBars(
    AnalyticsPeriod period,
    Map<DateTime, double> dailyTotals,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (period) {
      case AnalyticsPeriod.week:
        return List.generate(7, (i) {
          final date = today.subtract(Duration(days: 6 - i));
          return ChartBar(
            label: _dayAbbr(date.weekday),
            totalMl: dailyTotals[date] ?? 0.0,
          );
        });

      case AnalyticsPeriod.month:
        return List.generate(4, (w) {
          var total = 0.0;
          for (var d = 0; d < 7; d++) {
            final date = today.subtract(Duration(days: 29 - (w * 7 + d)));
            total += dailyTotals[date] ?? 0.0;
          }
          return ChartBar(label: 'Wk ${w + 1}', totalMl: total);
        });

      case AnalyticsPeriod.threeMonths:
        return List.generate(3, (i) {
          final month = DateTime(now.year, now.month - (2 - i), 1);
          final total = dailyTotals.entries
              .where((e) =>
                  e.key.year == month.year && e.key.month == month.month)
              .fold(0.0, (sum, e) => sum + e.value);
          return ChartBar(label: _monthAbbr(month.month), totalMl: total);
        });

      case AnalyticsPeriod.year:
        return List.generate(12, (i) {
          final month = DateTime(now.year, now.month - (11 - i), 1);
          final total = dailyTotals.entries
              .where((e) =>
                  e.key.year == month.year && e.key.month == month.month)
              .fold(0.0, (sum, e) => sum + e.value);
          return ChartBar(label: _monthAbbr(month.month), totalMl: total);
        });

      case AnalyticsPeriod.allTime:
        if (dailyTotals.isEmpty) return [];
        final years =
            dailyTotals.keys.map((d) => d.year).toSet().toList()..sort();
        return years.map((y) {
          final total = dailyTotals.entries
              .where((e) => e.key.year == y)
              .fold(0.0, (sum, e) => sum + e.value);
          return ChartBar(label: '$y', totalMl: total);
        }).toList();
    }
  }
}

String _dayAbbr(int weekday) {
  const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return days[weekday - 1];
}

String _monthAbbr(int month) {
  const months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];
  return months[month - 1];
}
