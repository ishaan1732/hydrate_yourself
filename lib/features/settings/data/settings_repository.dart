import 'package:drift/drift.dart';
import 'package:hydrate_yourself/database/app_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/hydration_calculator.dart';
import '../../../database/daos/drink_types_dao.dart';
import '../../../database/daos/user_profile_dao.dart';
import '../../../database/daos/water_logs_dao.dart';
import '../../onboarding/domain/user_profile_model.dart';

class SettingsRepository {
  SettingsRepository(
    this._userProfileDao,
    this._prefs, {
    required this._waterLogsDao,
    required this._drinkTypesDao,
  });

  final UserProfileDao _userProfileDao;
  final WaterLogsDao _waterLogsDao;
  final DrinkTypesDao _drinkTypesDao;
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
      weightKg: weightKg,
      activityLevel: profile.activityLevel,
      gender: profile.gender,
      isPregnant: profile.isPregnant,
      climateType: profile.climateType,
    );
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

  Future<void> updateWakeTime(int hour, int minute) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      wakeHour: Value(hour),
      wakeMinute: Value(minute),
    ));
  }

  Future<void> updateSleepTime(int hour, int minute) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      sleepHour: Value(hour),
      sleepMinute: Value(minute),
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
      weightKg: profile.weightKg,
      activityLevel: level,
      gender: profile.gender,
      isPregnant: profile.isPregnant,
      climateType: profile.climateType,
    );
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      activityLevel: Value(level),
      dailyGoalMl: Value(newGoal),
    ));
  }

  Future<void> updateGender(String gender) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    final newGoal = HydrationCalculator.calculateDailyGoalMl(
      weightKg: profile.weightKg,
      activityLevel: profile.activityLevel,
      gender: gender,
      isPregnant: profile.isPregnant,
      climateType: profile.climateType,
    );
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      gender: Value(gender),
      dailyGoalMl: Value(newGoal),
    ));
  }

  Future<void> updateIsPregnant(bool value) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    final newGoal = HydrationCalculator.calculateDailyGoalMl(
      weightKg: profile.weightKg,
      activityLevel: profile.activityLevel,
      gender: profile.gender,
      isPregnant: value,
      climateType: profile.climateType,
    );
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      isPregnant: Value(value),
      dailyGoalMl: Value(newGoal),
    ));
  }

  Future<void> deleteAllData() async {
    await _waterLogsDao.deleteAllLogs();
    await _userProfileDao.deleteProfile();
    await _drinkTypesDao.resetToDefaults();
    await _prefs.clear();
    await _prefs.setBool(AppConstants.prefHasCompletedOnboarding, false);
    await _prefs.setString('theme_mode', 'system');
  }

  Future<void> updateClimateType(String climate) async {
    final profile = await _userProfileDao.getProfile();
    if (profile == null) return;
    final newGoal = HydrationCalculator.calculateDailyGoalMl(
      weightKg: profile.weightKg,
      activityLevel: profile.activityLevel,
      gender: profile.gender,
      isPregnant: profile.isPregnant,
      climateType: climate,
    );
    await _userProfileDao.updateProfile(UserProfileCompanion(
      id: Value(profile.id),
      climateType: Value(climate),
      dailyGoalMl: Value(newGoal),
    ));
  }
}
