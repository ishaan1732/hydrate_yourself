import 'package:flutter/widgets.dart';
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

  /// Registered by HomeScreen to handle DRINK_250ML when app is in foreground.
  void Function(int amountMl)? _foregroundDrinkCallback;

  void registerForegroundDrinkCallback(void Function(int amountMl)? callback) {
    _foregroundDrinkCallback = callback;
  }

  Future<void> initialize({
    required void Function(NotificationResponse) onBackground,
  }) async {
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
        debugPrint('=== FG HANDLER: actionId=${response.actionId} ===');
        if (response.actionId == 'DRINK_250ML') {
          debugPrint('=== FG HANDLER: processing DRINK_250ML ===');
          _foregroundDrinkCallback?.call(250);
          return;
        }
        // Non-action tap — deep link handled in app_router
      },
      onDidReceiveBackgroundNotificationResponse: onBackground,
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

  /// Requests exact alarm permission on Android 12+ if not already granted.
  Future<void> requestExactAlarmPermissionIfNeeded() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final canSchedule = await androidPlugin?.canScheduleExactNotifications();
    if (canSchedule == false) {
      await androidPlugin?.requestExactAlarmsPermission();
    }
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
      if (!notificationsEnabled || intervalMinutes == 0) return;

      await _plugin.cancelAll();

      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      final canScheduleExact =
          await androidPlugin?.canScheduleExactNotifications() ?? false;
      final scheduleMode = canScheduleExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexact;

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
            androidScheduleMode: scheduleMode,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );

          notificationId++;
        }

        scheduledTime = scheduledTime.add(Duration(minutes: intervalMinutes));
      }
    } catch (e, stack) {
      debugPrint('scheduleRemindersForToday FAILED: $e');
      debugPrint('Stack: $stack');
    }
  }

  Future<void> scheduleTestWithAction(tz.TZDateTime time) async {
    debugPrint('=== scheduleTestWithAction called for $time ===');

    final canSchedule = await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.canScheduleExactNotifications();
    debugPrint('=== Can schedule exact: $canSchedule ===');

    await _plugin.zonedSchedule(
      997,
      'Debug test 💧',
      'Tap "Drink 250ml" below to test action button',
      time,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'water_reminders',
          'Water Reminders',
          importance: Importance.max,
          priority: Priority.max,
          actions: const <AndroidNotificationAction>[
            AndroidNotificationAction(
              'DRINK_250ML',
              'Drink 250ml',
              cancelNotification: true,
              showsUserInterface: false,
            ),
          ],
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    debugPrint('=== zonedSchedule completed ===');
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
