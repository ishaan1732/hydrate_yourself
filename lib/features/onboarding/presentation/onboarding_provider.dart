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
    this.activityLevel = AppConstants.defaultActivityLevel,
    this.wakeHour = AppConstants.defaultWakeHour,
    this.sleepHour = AppConstants.defaultSleepHour,
    this.reminderIntervalMinutes = AppConstants.defaultReminderIntervalMinutes,
  });

  final String name;
  final double weightKg;
  final int activityLevel;
  final int wakeHour;
  final int sleepHour;
  final int reminderIntervalMinutes;

  OnboardingFormData copyWith({
    String? name,
    double? weightKg,
    int? activityLevel,
    int? wakeHour,
    int? sleepHour,
    int? reminderIntervalMinutes,
  }) =>
      OnboardingFormData(
        name: name ?? this.name,
        weightKg: weightKg ?? this.weightKg,
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

  void updateActivityLevel(int level) =>
      state = AsyncData(state.requireValue.copyWith(activityLevel: level));

  void updateWakeHour(int hour) =>
      state = AsyncData(state.requireValue.copyWith(wakeHour: hour));

  void updateSleepHour(int hour) =>
      state = AsyncData(state.requireValue.copyWith(sleepHour: hour));

  void updateReminderInterval(int minutes) =>
      state = AsyncData(
          state.requireValue.copyWith(reminderIntervalMinutes: minutes));

  Future<void> completeOnboarding() async {
    final data = state.requireValue;
    final dailyGoalMl = HydrationCalculator.calculateDailyGoalMl(
        data.weightKg, data.activityLevel);
    final prefs = await SharedPreferences.getInstance();
    final userProfileDao = ref.read(userProfileDaoProvider);
    final repository = OnboardingRepository(userProfileDao, prefs);
    await repository.saveProfileAndComplete(
      name: data.name,
      weightKg: data.weightKg,
      activityLevel: data.activityLevel,
      dailyGoalMl: dailyGoalMl,
      wakeHour: data.wakeHour,
      sleepHour: data.sleepHour,
      reminderIntervalMinutes: data.reminderIntervalMinutes,
    );
    ref.read(onboardingCompleteProvider.notifier).state = true;
  }
}
