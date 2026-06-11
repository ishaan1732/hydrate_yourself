import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/drink_types_table.dart';

part 'drink_types_dao.g.dart';

@DriftAccessor(tables: [DrinkTypes])
class DrinkTypesDao extends DatabaseAccessor<AppDatabase>
    with _$DrinkTypesDaoMixin {
  DrinkTypesDao(super.db);

  Future<List<DrinkTypesData>> getAllDrinkTypes() =>
      (select(drinkTypes)
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .get();

  Stream<List<DrinkTypesData>> watchAllDrinkTypes() =>
      (select(drinkTypes)
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<int> insertDrinkType(DrinkTypesCompanion drinkType) =>
      into(drinkTypes).insert(drinkType);

  Future<void> resetToDefaults() async {
    await delete(drinkTypes).go();
    await into(drinkTypes).insert(DrinkTypesCompanion(
      name: const Value('Water'),
      hydrationCoefficient: const Value(1.0),
      iconName: const Value('water_drop'),
      colorHex: const Value('#0090C8'),
      isCustom: const Value(false),
      sortOrder: const Value(0),
    ));
    await into(drinkTypes).insert(DrinkTypesCompanion(
      name: const Value('Coffee'),
      hydrationCoefficient: const Value(0.5),
      iconName: const Value('coffee'),
      colorHex: const Value('#795548'),
      isCustom: const Value(false),
      sortOrder: const Value(1),
    ));
    await into(drinkTypes).insert(DrinkTypesCompanion(
      name: const Value('Tea'),
      hydrationCoefficient: const Value(0.7),
      iconName: const Value('emoji_food_beverage'),
      colorHex: const Value('#8D6E63'),
      isCustom: const Value(false),
      sortOrder: const Value(2),
    ));
    await into(drinkTypes).insert(DrinkTypesCompanion(
      name: const Value('Juice'),
      hydrationCoefficient: const Value(0.8),
      iconName: const Value('local_drink'),
      colorHex: const Value('#FF9800'),
      isCustom: const Value(false),
      sortOrder: const Value(3),
    ));
    await into(drinkTypes).insert(DrinkTypesCompanion(
      name: const Value('Soda'),
      hydrationCoefficient: const Value(0.7),
      iconName: const Value('sports_bar'),
      colorHex: const Value('#78909C'),
      isCustom: const Value(false),
      sortOrder: const Value(4),
    ));
  }

  Future<bool> deleteDrinkType(int id) async {
    final row = await (select(drinkTypes)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null || !row.isCustom) return false;
    final deleted =
        await (delete(drinkTypes)..where((t) => t.id.equals(id))).go();
    return deleted > 0;
  }
}
