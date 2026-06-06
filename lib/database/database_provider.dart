import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'daos/drink_types_dao.dart';
import 'daos/user_profile_dao.dart';
import 'daos/water_logs_dao.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final userProfileDaoProvider = Provider<UserProfileDao>((ref) {
  return ref.watch(databaseProvider).userProfileDao;
});

final drinkTypesDaoProvider = Provider<DrinkTypesDao>((ref) {
  return ref.watch(databaseProvider).drinkTypesDao;
});

final waterLogsDaoProvider = Provider<WaterLogsDao>((ref) {
  return ref.watch(databaseProvider).waterLogsDao;
});
