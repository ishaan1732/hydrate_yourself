import 'package:drift/drift.dart';

import '../../../database/app_database.dart';
import '../../../database/daos/drink_types_dao.dart';
import '../../../database/daos/user_profile_dao.dart';
import '../../../database/daos/water_logs_dao.dart';
import '../domain/drink_type_model.dart';
import '../domain/water_log_model.dart';
import '../../onboarding/domain/user_profile_model.dart';

class HomeRepository {
  HomeRepository(
    this._waterLogsDao,
    this._userProfileDao,
    this._drinkTypesDao,
  );

  final WaterLogsDao _waterLogsDao;
  final UserProfileDao _userProfileDao;
  final DrinkTypesDao _drinkTypesDao;

  Stream<double> watchTodayTotalMl() => _waterLogsDao.watchTodayTotalMl();

  Stream<List<DrinkTypeModel>> watchDrinkTypes() =>
      _drinkTypesDao.watchAllDrinkTypes().map(
            (list) => list.map(DrinkTypeModel.fromDrift).toList(),
          );

  Future<UserProfileModel?> getProfile() async {
    final data = await _userProfileDao.getProfile();
    if (data == null) return null;
    return UserProfileModel.fromDrift(data);
  }

  Future<void> addLog({
    required double amountMl,
    required int drinkTypeId,
  }) =>
      _waterLogsDao.insertLog(WaterLogsCompanion.insert(
        loggedAt: DateTime.now(),
        amountMl: amountMl,
        drinkTypeId: drinkTypeId,
      ));

  Future<void> addLogAtTime({
    required double amountMl,
    required int drinkTypeId,
    required DateTime loggedAt,
  }) =>
      _waterLogsDao.insertLog(WaterLogsCompanion.insert(
        loggedAt: loggedAt,
        amountMl: amountMl,
        drinkTypeId: drinkTypeId,
      ));

  Future<WaterLogModel?> getLastLog() async {
    final db = _waterLogsDao.attachedDatabase;
    final result = await (db.select(db.waterLogs)
          ..orderBy([(l) => OrderingTerm.desc(l.loggedAt)])
          ..limit(1))
        .get();

    if (result.isEmpty) return null;

    final log = result.first;
    final drinkTypesList = await _drinkTypesDao.getAllDrinkTypes();
    final drinkType = drinkTypesList.firstWhere(
      (dt) => dt.id == log.drinkTypeId,
    );

    return WaterLogModel.fromDrift(log, drinkType);
  }

  Future<void> deleteLog(int id) async {
    await _waterLogsDao.deleteLog(id);
  }
}
