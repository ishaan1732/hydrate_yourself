import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/drink_types_table.dart';
import '../tables/water_logs_table.dart';

part 'water_logs_dao.g.dart';

@DriftAccessor(tables: [WaterLogs, DrinkTypes])
class WaterLogsDao extends DatabaseAccessor<AppDatabase>
    with _$WaterLogsDaoMixin {
  WaterLogsDao(super.db);

  Future<int> insertLog(WaterLogsCompanion log) =>
      into(waterLogs).insert(log);

  Future<bool> deleteLog(int id) async {
    final deleted =
        await (delete(waterLogs)..where((t) => t.id.equals(id))).go();
    return deleted > 0;
  }

  Stream<List<WaterLogsData>> watchTodayLogs() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return (select(waterLogs)
          ..where((t) => t.loggedAt.isBetweenValues(start, end))
          ..orderBy([(t) => OrderingTerm.desc(t.loggedAt)]))
        .watch();
  }

  Stream<double> watchTodayTotalMl() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final amountSum = waterLogs.amountMl.sum();
    return (selectOnly(waterLogs)
          ..addColumns([amountSum])
          ..where(waterLogs.loggedAt.isBetweenValues(start, end)))
        .map((row) => row.read(amountSum) ?? 0.0)
        .watchSingle();
  }

  Future<List<WaterLogsData>> getLogsForDateRange(
      DateTime start, DateTime end) =>
      (select(waterLogs)
            ..where((t) => t.loggedAt.isBetweenValues(start, end))
            ..orderBy([(t) => OrderingTerm.asc(t.loggedAt)]))
          .get();

  Future<Map<DateTime, double>> getDailyTotals(int lastNDays) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: lastNDays - 1));
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);

    final logs = await (select(waterLogs)
          ..where((t) => t.loggedAt.isBetweenValues(start, end)))
        .get();

    final totals = <DateTime, double>{};
    for (final log in logs) {
      final date =
          DateTime(log.loggedAt.year, log.loggedAt.month, log.loggedAt.day);
      totals[date] = (totals[date] ?? 0.0) + log.amountMl;
    }
    return totals;
  }
}
