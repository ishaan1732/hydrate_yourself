import 'package:drift/drift.dart';

import 'drink_types_table.dart';

@DataClassName('WaterLogsData')
class WaterLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get loggedAt => dateTime()();
  RealColumn get amountMl => real()();
  IntColumn get drinkTypeId => integer().references(DrinkTypes, #id)();
}
