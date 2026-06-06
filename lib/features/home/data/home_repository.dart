import 'package:drift/drift.dart';

import '../../../database/app_database.dart';
import '../../../database/daos/drink_types_dao.dart';
import '../../../database/daos/user_profile_dao.dart';
import '../../../database/daos/water_logs_dao.dart';
import '../domain/drink_type_model.dart';
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
        note: const Value(null),
      ));
}
