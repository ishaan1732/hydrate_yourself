import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/hydration_calculator.dart';
import '../../../database/database_provider.dart';
import '../data/onboarding_repository.dart';

part 'onboarding_provider.g.dart';

class OnboardingFormData {
  OnboardingFormData({
    this.name = '',
    this.weightKg = AppConstants.defaultWeightKg,
    this.weightUnit = AppConstants.unitKg,
    this.activityLevel = AppConstants.defaultActivityLevel,
    this.wakeHour = AppConstants.defaultWakeHour,
    this.sleepHour = AppConstants.defaultSleepHour,
    this.reminderIntervalMinutes = AppConstants.defaultReminderIntervalMinutes,
  });

  final String name;
  final double weightKg;
  final String weightUnit;
  final int activityLevel;
  final int wakeHour;
  final int sleepHour;
  final int reminderIntervalMinutes;

  OnboardingFormData copyWith({
    String? name,
    double? weightKg,
    String? weightUnit,
    int? activityLevel,
    int? wakeHour,
    int? sleepHour,
    int? reminderIntervalMinutes,
  }) =>
      OnboardingFormData(
        name: name ?? this.name,
        weightKg: weightKg ?? this.weightKg,
        weightUnit: weightUnit ?? this.weightUnit,
        activityLevel: activityLevel ?? this.activityLevel,
        wakeHour: wakeHour ?? this.wakeHour,
        sleepHour: sleepHour ?? this.sleepHour,
        reminderIntervalMinutes:
            reminderIntervalMinutes ?? this.reminderIntervalMinutes,
      );
}

final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  FutureOr<OnboardingFormData> build() => OnboardingFormData();

  void updateName(String name) =>
      state = AsyncData(state.requireValue.copyWith(name: name));

  void updateWeight(double weightKg) =>
      state = AsyncData(state.requireValue.copyWith(weightKg: weightKg));

  void updateWeightUnit(String unit) =>
      state = AsyncData(state.requireValue.copyWith(weightUnit: unit));

  void updateActivityLevel(int level) =>
      state = AsyncData(state.requireValue.copyWith(activityLevel: level));

  void updateWakeHour(int hour) =>
      state = AsyncData(state.requireValue.copyWith(wakeHour: hour));

  void updateSleepHour(int hour) =>
      state = AsyncData(state.requireValue.copyWith(sleepHour: hour));

  void updateReminderInterval(int minutes) =>
      state = AsyncData(
          state.requireValue.copyWith(reminderIntervalMinutes: minutes));

  Future<void> completeOnboarding({
    required String name,
    required double weightKg,
    required String weightUnit,
    required int activityLevel,
    required int wakeHour,
    required int sleepHour,
    required int reminderIntervalMinutes,
  }) async {
    final dailyGoalMl = HydrationCalculator.calculateDailyGoalMl(
        weightKg, activityLevel);
    final prefs = await SharedPreferences.getInstance();
    final userProfileDao = ref.read(userProfileDaoProvider);
    final repository = OnboardingRepository(userProfileDao, prefs);
    await repository.saveProfileAndComplete(
      name: name,
      weightKg: weightKg,
      weightUnit: weightUnit,
      activityLevel: activityLevel,
      dailyGoalMl: dailyGoalMl,
      wakeHour: wakeHour,
      sleepHour: sleepHour,
      reminderIntervalMinutes: reminderIntervalMinutes,
    );
    ref.read(onboardingCompleteProvider.notifier).state = true;
  }
}
