import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import '../../../core/constants/app_constants.dart';
import 'notification_service.dart';

const String reminderTaskName = 'hydrate_reminder_task';
const String reminderTaskUnique = 'hydrate_reminder_periodic';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      if (task == reminderTaskName) {
        final prefs = await SharedPreferences.getInstance();

        final notificationsEnabled =
            prefs.getBool('notifications_enabled') ?? true;
        if (!notificationsEnabled) return true;

        final intervalMinutes =
            prefs.getInt('reminder_interval_minutes') ??
                AppConstants.defaultReminderIntervalMinutes;

        // Clear stale goal-achieved flag from a previous day
        final now = DateTime.now();
        final todayStr =
            '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
        final achievedDate =
            prefs.getString(AppConstants.prefGoalAchievedDate);
        if (achievedDate != null && achievedDate != todayStr) {
          await prefs.remove(AppConstants.prefGoalAchievedDate);
        }
        if (achievedDate == todayStr) return true;

        final service = NotificationService();
        await service.initialize();
        final should = await service.shouldShowReminder(intervalMinutes);
        if (should) {
          await service.showReminderNotification();
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  });
}

class BackgroundTaskManager {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  static Future<void> scheduleReminders(int intervalMinutes) async {
    await Workmanager().cancelByUniqueName(reminderTaskUnique);

    if (intervalMinutes <= 0) return;

    final frequency = Duration(minutes: intervalMinutes);

    await Workmanager().registerPeriodicTask(
      reminderTaskUnique,
      reminderTaskName,
      frequency: frequency,
      constraints: Constraints(
        networkType: NetworkType.notRequired,
        requiresBatteryNotLow: false,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
    );
  }

  static Future<void> cancelReminders() async {
    await Workmanager().cancelByUniqueName(reminderTaskUnique);
  }
}
