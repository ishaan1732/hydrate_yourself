import 'package:drift/drift.dart';
import 'package:hydrate_yourself/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/hydration_calculator.dart';
import '../../../database/daos/user_profile_dao.dart';
import '../../onboarding/domain/user_profile_model.dart';

class SettingsRepository {
  SettingsRepository(this._userProfileDao, this._prefs);

  final UserProfileDao _userProfileDao;
  final SharedPreferences _prefs;

  Future<UserProfileModel?> getProfile() async {
    final data = await _userProfileDao.getProfile();
    if (data == null) return null;
    return UserProfileModel.fromDrift(data);
  }

  Future<void> updateGoal(int goalMl) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      dailyGoalMl: Value(goalMl),
    ));
  }

  Future<void> updateUnit(String unit) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      unit: Value(unit),
    ));
  }

  Future<void> updateName(String name) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      name: Value(name),
    ));
  }

  Future<void> updateWeight(double weightKg, String weightUnit) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    final newGoal = HydrationCalculator.calculateDailyGoalMl(
        weightKg, profile.activityLevel);
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      weightKg: Value(weightKg),
      weightUnit: Value(weightUnit),
      dailyGoalMl: Value(newGoal),
    ));
  }

  Future<void> updateWeightUnit(String unit) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      weightUnit: Value(unit),
    ));
  }

  Future<void> updateWakeHour(int hour) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      wakeHour: Value(hour),
    ));
  }

  Future<void> updateSleepHour(int hour) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      sleepHour: Value(hour),
    ));
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      notificationsEnabled: Value(enabled),
    ));
    await _prefs.setBool('notifications_enabled', enabled);
  }

  Future<void> updateReminderInterval(int minutes) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      reminderIntervalMinutes: Value(minutes),
    ));
    await _prefs.setInt('reminder_interval_minutes', minutes);
  }

  Future<void> updateActivityLevel(int level) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    final newGoal = HydrationCalculator.calculateDailyGoalMl(
        profile.weightKg, level);
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      activityLevel: Value(level),
      dailyGoalMl: Value(newGoal),
    ));
  }
}
