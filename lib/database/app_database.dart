import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'daos/drink_types_dao.dart';
import 'daos/user_profile_dao.dart';
import 'daos/water_logs_dao.dart';
import 'tables/drink_types_table.dart';
import 'tables/user_profile_table.dart';
import 'tables/water_logs_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [WaterLogs, DrinkTypes, UserProfile],
  daos: [UserProfileDao, DrinkTypesDao, WaterLogsDao],
)
class AppDatabase extends _$AppDatabase {
  static const String _dbName = 'hydrate_yourself';

  AppDatabase() : super(driftDatabase(name: _dbName));

  // Used by background isolate — explicit path required
  AppDatabase._withExecutor(super.executor);

  static AppDatabase openWithPath(String dbPath) =>
      AppDatabase._withExecutor(NativeDatabase(File(dbPath)));

  /// Resolves the exact on-disk file drift_flutter's driftDatabase() opens
  /// (ApplicationDocumentsDirectory/$_dbName.sqlite), so a background
  /// isolate can cache and later reopen the SAME file via [openWithPath]
  /// instead of resolving it independently.
  static Future<String> resolveDbPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(dir.path, '$_dbName.sqlite');
  }

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
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
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.addColumn(userProfile, userProfile.weightUnit);
          }
          if (from < 3) {
            await m.addColumn(userProfile, userProfile.wakeMinute);
            await m.addColumn(userProfile, userProfile.sleepMinute);
          }
          if (from < 4) {
            await m.addColumn(userProfile, userProfile.gender);
            await m.addColumn(userProfile, userProfile.isPregnant);
            await m.addColumn(userProfile, userProfile.climateType);
          }
          if (from < 5) {
            await m.dropColumn(waterLogs, 'note');
          }
        },
      );
}
