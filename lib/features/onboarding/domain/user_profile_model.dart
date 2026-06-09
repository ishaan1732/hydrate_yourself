import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:hydrate_yourself/database/app_database.dart';

import '../../../database/tables/user_profile_table.dart';

part 'user_profile_model.freezed.dart';

@freezed
class UserProfileModel with _$UserProfileModel {
  const factory UserProfileModel({
    required int id,
    required String name,
    required double weightKg,
    required int activityLevel,
    required int dailyGoalMl,
    required String unit,
    required String weightUnit,
    required String gender,
    required bool isPregnant,
    required String climateType,
    required int wakeHour,
    required int wakeMinute,
    required int sleepHour,
    required int sleepMinute,
    required int reminderIntervalMinutes,
    required bool notificationsEnabled,
  }) = _UserProfileModel;

  factory UserProfileModel.fromDrift(UserProfileData data) => UserProfileModel(
        id: data.id,
        name: data.name,
        weightKg: data.weightKg,
        activityLevel: data.activityLevel,
        dailyGoalMl: data.dailyGoalMl,
        unit: data.unit,
        weightUnit: data.weightUnit,
        gender: data.gender,
        isPregnant: data.isPregnant,
        climateType: data.climateType,
        wakeHour: data.wakeHour,
        wakeMinute: data.wakeMinute,
        sleepHour: data.sleepHour,
        sleepMinute: data.sleepMinute,
        reminderIntervalMinutes: data.reminderIntervalMinutes,
        notificationsEnabled: data.notificationsEnabled,
      );
}
