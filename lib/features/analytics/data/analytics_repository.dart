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

    final int daysInPeriod = switch (period) {
      AnalyticsPeriod.week        => 7,
      AnalyticsPeriod.month       => 30,
      AnalyticsPeriod.threeMonths => 90,
      AnalyticsPeriod.year        => 365,
      AnalyticsPeriod.allTime     => max(dailyTotals.length, 1),
    };

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

    final chartPoints = _buildChartPoints(period, dailyTotals);

    return AnalyticsSummary(
      averageDailyMl: averageDailyMl,
      bestDayMl: bestDayMl,
      daysGoalMet: daysGoalMet,
      daysInPeriod: daysInPeriod,
      totalMl: totalMl,
      goalMl: goalMl,
      drinkTypeTotals: drinkTypeTotals,
      drinkTypeColors: drinkTypeColors,
      chartPoints: chartPoints,
    );
  }

  List<ChartDataPoint> _buildChartPoints(
    AnalyticsPeriod period,
    Map<DateTime, double> dailyTotals,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    switch (period) {
      // DAILY: one point per day, y = total ml that day
      case AnalyticsPeriod.week:
        return List.generate(7, (i) {
          final date = today.subtract(Duration(days: 6 - i));
          return ChartDataPoint(
            x: i.toDouble(),
            y: dailyTotals[date] ?? 0.0,
            label: _dayAbbr(date.weekday),
          );
        });

      case AnalyticsPeriod.month:
        return List.generate(30, (i) {
          final date = today.subtract(Duration(days: 29 - i));
          return ChartDataPoint(
            x: i.toDouble(),
            y: dailyTotals[date] ?? 0.0,
            label: '${_monthAbbr(date.month)} ${date.day}',
          );
        });

      // WEEKLY: 13 buckets of 7 days, y = average daily ml per bucket
      case AnalyticsPeriod.threeMonths:
        final startDay = today.subtract(const Duration(days: 90));
        return List.generate(13, (w) {
          var total = 0.0;
          for (var d = 0; d < 7; d++) {
            final date = startDay.add(Duration(days: w * 7 + d));
            if (!date.isAfter(today)) total += dailyTotals[date] ?? 0.0;
          }
          return ChartDataPoint(
            x: w.toDouble(),
            y: total / 7,
            label: 'W${w + 1}',
          );
        });

      // MONTHLY: calendar months, y = average daily ml per month
      case AnalyticsPeriod.year:
        return List.generate(12, (i) {
          final month = DateTime(now.year, now.month - (11 - i), 1);
          final isCurrentMonth =
              month.year == now.year && month.month == now.month;
          final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
          final effectiveDays = isCurrentMonth ? now.day : daysInMonth;
          final total = dailyTotals.entries
              .where(
                  (e) => e.key.year == month.year && e.key.month == month.month)
              .fold(0.0, (sum, e) => sum + e.value);
          return ChartDataPoint(
            x: i.toDouble(),
            y: effectiveDays > 0 ? total / effectiveDays : 0.0,
            label: _monthAbbr(month.month),
          );
        });

      case AnalyticsPeriod.allTime:
        if (dailyTotals.isEmpty) return [];
        final sortedDates = dailyTotals.keys.toList()..sort();
        final firstDate = sortedDates.first;
        final daySpan = today.difference(firstDate).inDays;

        if (daySpan < 60) {
          // Daily — one point per day; widget applies label-interval filtering
          final totalDays = daySpan + 1;
          return List.generate(totalDays, (i) {
            final date = firstDate.add(Duration(days: i));
            return ChartDataPoint(
              x: i.toDouble(),
              y: dailyTotals[date] ?? 0.0,
              label: '${_monthAbbr(date.month)} ${date.day}',
            );
          });
        } else if (daySpan < 180) {
          // Weekly — 7-day buckets; widget applies label-interval filtering
          final totalWeeks = (daySpan / 7).ceil();
          return List.generate(totalWeeks, (w) {
            var total = 0.0;
            var count = 0;
            for (var d = 0; d < 7; d++) {
              final date = firstDate.add(Duration(days: w * 7 + d));
              if (!date.isAfter(today)) {
                total += dailyTotals[date] ?? 0.0;
                count++;
              }
            }
            return ChartDataPoint(
              x: w.toDouble(),
              y: count > 0 ? total / count : 0.0,
              label: 'Wk ${w + 1}',
            );
          });
        } else {
          // Monthly — calendar months with month+year labels
          final months = dailyTotals.keys
              .map((d) => DateTime(d.year, d.month, 1))
              .toSet()
              .toList()
            ..sort();
          return months.asMap().entries.map((entry) {
            final i = entry.key;
            final month = entry.value;
            final isCurrentMonth =
                month.year == now.year && month.month == now.month;
            final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
            final effectiveDays = isCurrentMonth ? now.day : daysInMonth;
            final total = dailyTotals.entries
                .where((e) =>
                    e.key.year == month.year && e.key.month == month.month)
                .fold(0.0, (sum, e) => sum + e.value);
            final yr = (month.year % 100).toString().padLeft(2, '0');
            return ChartDataPoint(
              x: i.toDouble(),
              y: effectiveDays > 0 ? total / effectiveDays : 0.0,
              label: "${_monthAbbr(month.month)} '$yr",
            );
          }).toList();
        }
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
