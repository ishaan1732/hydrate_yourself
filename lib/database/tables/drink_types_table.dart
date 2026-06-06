import 'package:drift/drift.dart';

@DataClassName('DrinkTypesData')
class DrinkTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(max: 50)();
  RealColumn get hydrationCoefficient =>
      real().withDefault(const Constant(1.0))();
  TextColumn get iconName => text()();
  TextColumn get colorHex => text()();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
