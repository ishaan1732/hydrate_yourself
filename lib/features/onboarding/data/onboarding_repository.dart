import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../database/app_database.dart';
import '../../../database/daos/user_profile_dao.dart';

class OnboardingRepository {
  OnboardingRepository(this._userProfileDao, this._prefs);

  final UserProfileDao _userProfileDao;
  final SharedPreferences _prefs;

  Future<bool> isOnboardingComplete() async =>
      _prefs.getBool(AppConstants.prefHasCompletedOnboarding) ?? false;

  Future<void> saveProfileAndComplete({
    required String name,
    required double weightKg,
    required String weightUnit,
    required int activityLevel,
    required int dailyGoalMl,
    required int wakeHour,
    required int wakeMinute,
    required int sleepHour,
    required int sleepMinute,
    required int reminderIntervalMinutes,
  }) async {
    await _userProfileDao.insertProfile(
      UserProfileCompanion.insert(
        name: name,
        weightKg: weightKg,
        activityLevel: activityLevel,
        dailyGoalMl: dailyGoalMl,
        wakeHour: Value(wakeHour),
        wakeMinute: Value(wakeMinute),
        sleepHour: Value(sleepHour),
        sleepMinute: Value(sleepMinute),
        reminderIntervalMinutes: Value(reminderIntervalMinutes),
        weightUnit: Value(weightUnit),
      ),
    );
    await _prefs.setBool(AppConstants.prefHasCompletedOnboarding, true);
  }
}
