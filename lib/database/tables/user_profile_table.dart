import 'package:drift/drift.dart';

@DataClassName('UserProfileData')
class UserProfile extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(max: 100)();
  RealColumn get weightKg => real()();
  IntColumn get activityLevel => integer()();
  IntColumn get dailyGoalMl => integer()();
  TextColumn get unit => text().withDefault(const Constant('ml'))();
  TextColumn get weightUnit => text().withDefault(const Constant('kg'))();
  TextColumn get gender =>
      text().withDefault(const Constant('male'))();
  BoolColumn get isPregnant =>
      boolean().withDefault(const Constant(false))();
  TextColumn get climateType =>
      text().withDefault(const Constant('moderate'))();
  IntColumn get wakeHour => integer().withDefault(const Constant(7))();
  IntColumn get sleepHour => integer().withDefault(const Constant(23))();
  IntColumn get wakeMinute => integer().withDefault(const Constant(0))();
  IntColumn get sleepMinute => integer().withDefault(const Constant(0))();
  IntColumn get reminderIntervalMinutes =>
      integer().withDefault(const Constant(90))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}
