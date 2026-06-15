import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/constants/app_constants.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();
  factory NotificationService() => instance;

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

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
    try {
      if (!notificationsEnabled || intervalMinutes == 0) {
        await _plugin.cancelAll();
        return;
      }

      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final canScheduleExact =
          await androidPlugin?.canScheduleExactNotifications() ?? false;
      final scheduleMode = canScheduleExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexact;

      await _plugin.cancelAll();

      final now = tz.TZDateTime.now(tz.local);
      final minScheduleTime = now.add(const Duration(minutes: 2));
      final todayWake = tz.TZDateTime(
          tz.local, now.year, now.month, now.day, wakeHour, wakeMinute);
      final todaySleep = tz.TZDateTime(
          tz.local, now.year, now.month, now.day, sleepHour, sleepMinute);

      // First slot is wake + interval, not wake itself
      int notificationId = 100;
      tz.TZDateTime scheduledTime =
          todayWake.add(Duration(minutes: intervalMinutes));

      final percentage =
          goalMl > 0 ? ((currentTotalMl / goalMl) * 100).round() : 0;
      final remaining = (goalMl - currentTotalMl).clamp(0, goalMl);
      final body = currentTotalMl >= goalMl
          ? 'Goal reached! 🎉 $currentTotalMl ml of $goalMl ml'
          : '$currentTotalMl ml of $goalMl ml ($percentage%) — $remaining ml to go';

      while (scheduledTime.isBefore(todaySleep)) {
        if (scheduledTime.isAfter(minScheduleTime)) {
          await _plugin.zonedSchedule(
            notificationId,
            'Time to hydrate! 💧',
            body,
            scheduledTime,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'water_reminders',
                'Water Reminders',
                channelDescription: 'Hydration reminders throughout the day',
                importance: Importance.high,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
              ),
            ),
            androidScheduleMode: scheduleMode,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );

          notificationId++;
        }

        scheduledTime = scheduledTime.add(Duration(minutes: intervalMinutes));
      }
    } catch (_) {}
  }

  // Debug tool — remove before final Play Store release
  Future<void> scheduleTestNotification() async {
    final scheduledTime =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 30));

    await _plugin.zonedSchedule(
      997,
      'Hydrate Yourself test 💧',
      'If you see this while phone is locked — '
          'notifications are working correctly!',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'water_reminders',
          'Water Reminders',
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
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
