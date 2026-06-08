class AppConstants {
  AppConstants._();

  // Hydration defaults
  static const int defaultDailyGoalMl = 2500;
  static const int minDailyGoalMl = 1500;
  static const int maxDailyGoalMl = 4000;
  static const double defaultWeightKg = 70.0;
  static const int defaultActivityLevel = 0;

  // Quick add amounts (ml)
  static const List<int> quickAddAmounts = [150, 250, 330, 500];

  // Reminder defaults
  static const int defaultReminderIntervalMinutes = 90;
  static const int minReminderIntervalMinutes = 30;
  static const int maxReminderIntervalMinutes = 240;
  static const int defaultWakeHour = 7;
  static const int defaultSleepHour = 23;

  // SharedPreferences keys
  static const String prefHasCompletedOnboarding = 'has_completed_onboarding';
  static const String prefSelectedUnit = 'selected_unit';
  static const String prefLastNotificationTime = 'last_notification_time';

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
}
