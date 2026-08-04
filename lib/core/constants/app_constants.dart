class AppConstants {
  AppConstants._();

  // Hydration defaults
  static const int defaultDailyGoalMl = 2500;
  static const int minDailyGoalMl = 1500;
  static const int maxDailyGoalMl = 4500;
  static const double defaultWeightKg = 70.0;
  static const int defaultActivityLevel = 0;

  // Quick add amounts (ml)
  static const List<int> quickAddAmounts = [150, 250, 330, 500];

  // Reminder defaults
  static const int defaultReminderIntervalMinutes = 90;
  static const int minReminderIntervalMinutes = 15;
  static const int maxReminderIntervalMinutes = 240;
  static const int defaultWakeHour = 7;
  static const int defaultSleepHour = 23;

  // SharedPreferences keys
  static const String prefHasCompletedOnboarding = 'has_completed_onboarding';
  static const String prefSelectedUnit = 'selected_unit';

  // Notification constants
  static const String notificationChannelId = 'hydrate_reminders';
  static const String notificationChannelName = 'Hydration Reminders';
  static const String notificationChannelDesc =
      'Reminds you to drink water throughout the day';
  static const int notificationId = 1001;

  // Animation durations (ms)
  static const int progressAnimationMs = 800;
  static const int celebrationAnimationMs = 2000;
  static const int pageTransitionMs = 300;

  // Unit constants
  static const String unitMl = 'ml';
  static const String unitOz = 'oz';
  static const String unitKg = 'kg';
  static const String unitLbs = 'lbs';
  static const String prefWeightUnit = 'weight_unit';

  // Progress notification
  static const int progressNotificationId = 1002;
  static const String progressChannelId = 'hydrate_progress';
  static const String progressChannelName = 'Daily Progress';
  static const String progressChannelDesc =
      'Shows your daily hydration progress';
  static const String prefLastCupSizeMl = 'last_cup_size_ml';
  static const String prefLastDrinkTypeId = 'last_drink_type_id';
  static const String prefTodayGoalMl = 'today_goal_ml';
  static const String prefCachedDbPath = 'cached_db_path';
  static const String prefPersistentNotificationEnabled =
      'persistent_notification_enabled';
  static const String persistentNotificationAddAction = 'add_water';

  // Gender
  static const String genderMale = 'male';
  static const String genderFemale = 'female';
  static const String defaultGender = 'male';

  // Climate
  static const String climateCold = 'cold';
  static const String climateModerate = 'moderate';
  static const String climateHot = 'hot';
  static const String climateVeryHot = 'very_hot';
  static const String defaultClimate = 'moderate';

  // Notification preferences
  static const String prefNotificationSound = 'notification_sound';
}
