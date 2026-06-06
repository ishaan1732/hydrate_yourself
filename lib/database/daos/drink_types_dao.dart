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

  Future<bool> deleteDrinkType(int id) async {
    final row = await (select(drinkTypes)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null || !row.isCustom) return false;
    final deleted =
        await (delete(drinkTypes)..where((t) => t.id.equals(id))).go();
    return deleted > 0;
  }
}
