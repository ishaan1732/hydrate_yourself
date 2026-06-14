import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/constants/app_constants.dart';
import '../background_notification_handler.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();
  factory NotificationService() => instance;

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final iosSettings = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'water_reminder',
          actions: [
            DarwinNotificationAction.plain(
              'DRINK_250ML',
              'Drink 250ml',
              options: const <DarwinNotificationActionOption>{},
            ),
          ],
        ),
      ],
    );

    final settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        // Foreground tap — deep link handled in app_router
      },
      onDidReceiveBackgroundNotificationResponse: notificationBackgroundHandler,
    );

    // Scheduled reminder channel (high priority, can have sound)
    const AndroidNotificationChannel reminderChannel = AndroidNotificationChannel(
      'water_reminders',
      'Water Reminders',
      description: 'Hydration reminders throughout the day',
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(reminderChannel);

  }

  Future<bool> requestPermissions() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      final result = await Permission.notification.request();
      return result.isGranted;
    }
    return status.isGranted;
  }

  /// Cancels all pending scheduled reminders then schedules one notification
  /// per interval slot from [wakeHour] to [sleepHour] for the rest of today.
  Future<void> scheduleRemindersForToday({
    required int wakeHour,
    required int wakeMinute,
    required int sleepHour,
    required int sleepMinute,
    required int intervalMinutes,
    required int currentTotalMl,
    required int goalMl,
    required bool notificationsEnabled,
  }) async {
    // Always cancel first to clear stale scheduled notifications
    await _plugin.cancelAll();

    if (!notificationsEnabled || intervalMinutes == 0) return;

    final now = tz.TZDateTime.now(tz.local);
    final minScheduleTime = now.add(const Duration(minutes: 2));
    final todayWake = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, wakeHour, wakeMinute);
    final todaySleep = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, sleepHour, sleepMinute);

    int notificationId = 100;
    tz.TZDateTime scheduledTime = todayWake;

    while (scheduledTime.isBefore(todaySleep)) {
      if (scheduledTime.isAfter(minScheduleTime)) {
        final percentage =
            goalMl > 0 ? ((currentTotalMl / goalMl) * 100).round() : 0;
        final remaining = goalMl - currentTotalMl;
        final remainingDisplay =
            remaining > 0 ? '$remaining ml to go' : 'Goal reached! 🎉';

        await _plugin.zonedSchedule(
          notificationId,
          'Time to hydrate! 💧',
          '$currentTotalMl ml of $goalMl ml ($percentage%) — $remainingDisplay',
          scheduledTime,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'water_reminders',
              'Water Reminders',
              channelDescription: 'Hydration reminders throughout the day',
              importance: Importance.high,
              priority: Priority.high,
              icon: '@mipmap/ic_launcher',
              actions: const [
                AndroidNotificationAction(
                  'DRINK_250ML',
                  'Drink 250ml',
                  cancelNotification: true,
                  showsUserInterface: false,
                ),
              ],
            ),
            iOS: const DarwinNotificationDetails(
              categoryIdentifier: 'water_reminder',
            ),
          ),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );

        notificationId++;
      }

      scheduledTime =
          scheduledTime.add(Duration(minutes: intervalMinutes));
    }
  }

  Future<void> markGoalAchievedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final todayStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    await prefs.setString(AppConstants.prefGoalAchievedDate, todayStr);
  }

  Future<void> updateLastLogTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      AppConstants.prefLastNotificationTime,
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}

/// Legacy background tap handler for the ongoing progress notification.
/// No longer registered as the background handler — kept for reference.
@pragma('vm:entry-point')
Future<void> onNotificationTapBackground(
    NotificationResponse response) async {
  if (response.payload != 'log_water') return;
  // Progress notification tap brings the app to foreground; handled there.
  debugPrint('Background notification tap: ${response.payload}');
}
