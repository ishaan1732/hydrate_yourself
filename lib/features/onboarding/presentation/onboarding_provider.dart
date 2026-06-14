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
    this.gender,
    this.isPregnant = false,
    this.climateType = AppConstants.defaultClimate,
    this.wakeHour = AppConstants.defaultWakeHour,
    this.wakeMinute = 0,
    this.sleepHour = AppConstants.defaultSleepHour,
    this.sleepMinute = 0,
    this.reminderIntervalMinutes = AppConstants.defaultReminderIntervalMinutes,
  });

  final String name;
  final double weightKg;
  final String weightUnit;
  final int activityLevel;
  final String? gender;
  final bool isPregnant;
  final String climateType;
  final int wakeHour;
  final int wakeMinute;
  final int sleepHour;
  final int sleepMinute;
  final int reminderIntervalMinutes;

  OnboardingFormData copyWith({
    String? name,
    double? weightKg,
    String? weightUnit,
    int? activityLevel,
    String? gender,
    bool? isPregnant,
    String? climateType,
    int? wakeHour,
    int? wakeMinute,
    int? sleepHour,
    int? sleepMinute,
    int? reminderIntervalMinutes,
  }) =>
      OnboardingFormData(
        name: name ?? this.name,
        weightKg: weightKg ?? this.weightKg,
        weightUnit: weightUnit ?? this.weightUnit,
        activityLevel: activityLevel ?? this.activityLevel,
        gender: gender ?? this.gender,
        isPregnant: isPregnant ?? this.isPregnant,
        climateType: climateType ?? this.climateType,
        wakeHour: wakeHour ?? this.wakeHour,
        wakeMinute: wakeMinute ?? this.wakeMinute,
        sleepHour: sleepHour ?? this.sleepHour,
        sleepMinute: sleepMinute ?? this.sleepMinute,
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

  void updateWakeTime(int hour, int minute) => state =
      AsyncData(state.requireValue.copyWith(wakeHour: hour, wakeMinute: minute));

  void updateSleepTime(int hour, int minute) => state =
      AsyncData(state.requireValue.copyWith(sleepHour: hour, sleepMinute: minute));

  void updateGender(String gender) =>
      state = AsyncData(state.requireValue.copyWith(gender: gender));

  void updateIsPregnant(bool value) =>
      state = AsyncData(state.requireValue.copyWith(isPregnant: value));

  void updateClimateType(String climate) =>
      state = AsyncData(state.requireValue.copyWith(climateType: climate));

  void updateReminderInterval(int minutes) =>
      state = AsyncData(
          state.requireValue.copyWith(reminderIntervalMinutes: minutes));

  Future<void> completeOnboarding({
    required String name,
    required double weightKg,
    required String weightUnit,
    required int activityLevel,
    required String gender,
    required bool isPregnant,
    required String climateType,
    required int wakeHour,
    required int wakeMinute,
    required int sleepHour,
    required int sleepMinute,
    required int reminderIntervalMinutes,
  }) async {
    final dailyGoalMl = HydrationCalculator.calculateDailyGoalMl(
      weightKg: weightKg,
      activityLevel: activityLevel,
      gender: gender,
      isPregnant: isPregnant,
      climateType: climateType,
    );
    final prefs = await SharedPreferences.getInstance();
    final userProfileDao = ref.read(userProfileDaoProvider);
    final repository = OnboardingRepository(userProfileDao, prefs);
    await repository.saveProfileAndComplete(
      name: name,
      weightKg: weightKg,
      weightUnit: weightUnit,
      activityLevel: activityLevel,
      gender: gender,
      isPregnant: isPregnant,
      climateType: climateType,
      dailyGoalMl: dailyGoalMl,
      wakeHour: wakeHour,
      wakeMinute: wakeMinute,
      sleepHour: sleepHour,
      sleepMinute: sleepMinute,
      reminderIntervalMinutes: reminderIntervalMinutes,
    );
    ref.read(onboardingCompleteProvider.notifier).state = true;
  }
}
