import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/extensions/double_extensions.dart';
import '../../../database/database_provider.dart';
import '../../../core/utils/hydration_calculator.dart';
import '../../onboarding/domain/user_profile_model.dart';
import '../../reminders/data/background_task.dart';
import '../data/settings_repository.dart';

part 'settings_provider.g.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Override in main.dart ProviderScope');
});

@riverpod
SettingsRepository settingsRepository(SettingsRepositoryRef ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return SettingsRepository(
    ref.watch(userProfileDaoProvider),
    prefs,
  );
}

@riverpod
Future<UserProfileModel?> settingsProfile(SettingsProfileRef ref) =>
    ref.watch(settingsRepositoryProvider).getProfile();

@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  @override
  Future<UserProfileModel?> build() async =>
      ref.watch(settingsRepositoryProvider).getProfile();

  Future<void> updateGoal(int goalMl) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(dailyGoalMl: goalMl));
    try {
      await ref.read(settingsRepositoryProvider).updateGoal(goalMl);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateUnit(String unit) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(unit: unit));
    try {
      await ref.read(settingsRepositoryProvider).updateUnit(unit);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateName(String name) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(name: name));
    try {
      await ref.read(settingsRepositoryProvider).updateName(name);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateWeight(double inputWeight, String weightUnit) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final weightKg = weightUnit == AppConstants.unitLbs
        ? inputWeight.lbsToKg
        : inputWeight;
    final newGoal = HydrationCalculator.calculateDailyGoalMl(
      weightKg: weightKg,
      activityLevel: current.activityLevel,
      gender: current.gender,
      isPregnant: current.isPregnant,
      climateType: current.climateType,
    );
    state = AsyncData(current.copyWith(
      weightKg: weightKg,
      dailyGoalMl: newGoal,
      weightUnit: weightUnit,
    ));
    try {
      await ref.read(settingsRepositoryProvider).updateWeight(weightKg, weightUnit);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateWeightUnit(String unit) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(weightUnit: unit));
    try {
      await ref.read(settingsRepositoryProvider).updateWeightUnit(unit);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateWakeHour(int hour) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(wakeHour: hour));
    try {
      await ref.read(settingsRepositoryProvider).updateWakeHour(hour);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateSleepHour(int hour) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(sleepHour: hour));
    try {
      await ref.read(settingsRepositoryProvider).updateSleepHour(hour);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateWakeTime(int hour, int minute) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(wakeHour: hour, wakeMinute: minute));
    try {
      await ref.read(settingsRepositoryProvider).updateWakeTime(hour, minute);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateSleepTime(int hour, int minute) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(sleepHour: hour, sleepMinute: minute));
    try {
      await ref.read(settingsRepositoryProvider).updateSleepTime(hour, minute);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateNotificationsEnabled(bool enabled) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(notificationsEnabled: enabled));
    try {
      await ref
          .read(settingsRepositoryProvider)
          .updateNotificationsEnabled(enabled);
      if (enabled) {
        final prefs = ref.read(sharedPreferencesProvider);
        final interval = prefs.getInt('reminder_interval_minutes') ??
            AppConstants.defaultReminderIntervalMinutes;
        await BackgroundTaskManager.scheduleReminders(interval);
      } else {
        await BackgroundTaskManager.cancelReminders();
      }
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateReminderInterval(int minutes) async {
    final current = state.valueOrNull;
    if (current == null) return;
    state = AsyncData(current.copyWith(reminderIntervalMinutes: minutes));
    try {
      await ref
          .read(settingsRepositoryProvider)
          .updateReminderInterval(minutes);
      await BackgroundTaskManager.scheduleReminders(minutes);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateActivityLevel(int level) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final newGoal = HydrationCalculator.calculateDailyGoalMl(
      weightKg: current.weightKg,
      activityLevel: level,
      gender: current.gender,
      isPregnant: current.isPregnant,
      climateType: current.climateType,
    );
    state = AsyncData(current.copyWith(
      activityLevel: level,
      dailyGoalMl: newGoal,
    ));
    try {
      await ref.read(settingsRepositoryProvider).updateActivityLevel(level);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateGender(String gender) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final newGoal = HydrationCalculator.calculateDailyGoalMl(
      weightKg: current.weightKg,
      activityLevel: current.activityLevel,
      gender: gender,
      isPregnant: current.isPregnant,
      climateType: current.climateType,
    );
    state = AsyncData(current.copyWith(gender: gender, dailyGoalMl: newGoal));
    try {
      await ref.read(settingsRepositoryProvider).updateGender(gender);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateIsPregnant(bool value) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final newGoal = HydrationCalculator.calculateDailyGoalMl(
      weightKg: current.weightKg,
      activityLevel: current.activityLevel,
      gender: current.gender,
      isPregnant: value,
      climateType: current.climateType,
    );
    state = AsyncData(current.copyWith(isPregnant: value, dailyGoalMl: newGoal));
    try {
      await ref.read(settingsRepositoryProvider).updateIsPregnant(value);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateClimateType(String climate) async {
    final current = state.valueOrNull;
    if (current == null) return;
    final newGoal = HydrationCalculator.calculateDailyGoalMl(
      weightKg: current.weightKg,
      activityLevel: current.activityLevel,
      gender: current.gender,
      isPregnant: current.isPregnant,
      climateType: climate,
    );
    state = AsyncData(
        current.copyWith(climateType: climate, dailyGoalMl: newGoal));
    try {
      await ref.read(settingsRepositoryProvider).updateClimateType(climate);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
