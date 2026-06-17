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

  static const String _soundChannelId = 'water_reminders';
  static const String _silentChannelId = 'water_reminders_silent';

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _soundChannelId,
        'Water Reminders',
        description: 'Hydration reminders throughout the day',
        importance: Importance.high,
        playSound: true,
      ),
    );
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _silentChannelId,
        'Water Reminders (Silent)',
        description: 'Silent hydration reminders',
        importance: Importance.low,
        playSound: false,
        enableVibration: false,
      ),
    );
  }

  Future<bool> requestPermissions() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      final result = await Permission.notification.request();
      return result.isGranted;
    }
    return status.isGranted;
  }

  Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }

  /// Cancels all pending scheduled reminders, then schedules one notification
  /// per interval slot from [wakeHour] to [sleepHour] for the remainder of
  /// today plus the next [scheduleHorizonDays] - 1 full days. Every one of
  /// the 5 reschedule triggers elsewhere in the app re-extends this horizon
  /// from whatever moment it fires.
  Future<void> scheduleRemindersForToday({
    required int wakeHour,
    required int wakeMinute,
    required int sleepHour,
    required int sleepMinute,
    required int intervalMinutes,
    required int currentTotalMl,
    required int goalMl,
    required bool notificationsEnabled,
    required bool soundEnabled,
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

      final channelId = soundEnabled ? _soundChannelId : _silentChannelId;
      final channelName =
          soundEnabled ? 'Water Reminders' : 'Water Reminders (Silent)';

      final now = tz.TZDateTime.now(tz.local);
      final minScheduleTime = now.add(const Duration(minutes: 2));

      // If sleep time, read as a plain time-of-day, falls at or
      // before wake time, the user's bedtime is after midnight
      // relative to their wake time (e.g. wake 6:00am, sleep
      // 12:00am/1:00am/2:00am) — so the sleep boundary belongs
      // to the calendar day AFTER wake's date, not the same one.
      final wakeMinutesOfDay = wakeHour * 60 + wakeMinute;
      final sleepMinutesOfDay = sleepHour * 60 + sleepMinute;
      final sleepCrossesMidnight = sleepMinutesOfDay <= wakeMinutesOfDay;

      int notificationId = 100;

      // Any of the 5 reschedule triggers (open app, log
      // water, undo, change settings, toggle sound) pushes
      // this horizon forward by another 7 days from that
      // moment. Only a user who never triggers any of those
      // for 7 fully consecutive days will see reminders stop.
      const scheduleHorizonDays = 7;

      for (int dayOffset = 0; dayOffset < scheduleHorizonDays; dayOffset++) {
        final targetDate = now.add(Duration(days: dayOffset));

        // First slot is wake + interval, not wake itself
        var slotTime = tz.TZDateTime(
          tz.local, targetDate.year, targetDate.month, targetDate.day,
          wakeHour, wakeMinute,
        ).add(Duration(minutes: intervalMinutes));

        final sleepDate = sleepCrossesMidnight
            ? targetDate.add(const Duration(days: 1))
            : targetDate;

        final sleepTime = tz.TZDateTime(
          tz.local, sleepDate.year, sleepDate.month, sleepDate.day,
          sleepHour, sleepMinute,
        );

        // Today (offset 0) shows real progress. Every other
        // day in the horizon is a future day with nothing
        // logged yet, so it always shows 0.
        final displayTotal = dayOffset == 0 ? currentTotalMl : 0;

        final percentage = goalMl > 0
            ? ((displayTotal / goalMl) * 100).round() : 0;
        final remaining = (goalMl - displayTotal).clamp(0, goalMl);
        final body = displayTotal >= goalMl
            ? 'Goal reached! 🎉 $displayTotal ml of $goalMl ml'
            : '$displayTotal ml of $goalMl ml ($percentage%) — $remaining ml to go';

        while (slotTime.isBefore(sleepTime)) {
          if (slotTime.isAfter(minScheduleTime)) {
            await _plugin.zonedSchedule(
              notificationId,
              'Time to hydrate! 💧',
              body,
              slotTime,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channelId,
                  channelName,
                  channelDescription: 'Hydration reminders throughout the day',
                  importance:
                      soundEnabled ? Importance.high : Importance.low,
                  priority: soundEnabled ? Priority.high : Priority.low,
                  playSound: soundEnabled,
                  enableVibration: soundEnabled,
                  icon: '@mipmap/ic_launcher',
                ),
              ),
              androidScheduleMode: scheduleMode,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
            );

            notificationId++;
          }

          slotTime = slotTime.add(Duration(minutes: intervalMinutes));
        }
      }
    } catch (_) {}
  }

  // Debug tools — remove before final Play Store release

  Future<void> scheduleTestWithSound() async {
    final time =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
    await _plugin.zonedSchedule(
      994,
      'Test — with sound 🔔',
      'You should hear a sound with this notification',
      time,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'water_reminders',
          'Water Reminders',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleTestSilent() async {
    final time =
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
    await _plugin.zonedSchedule(
      995,
      'Test — silent 🔕',
      'You should NOT hear any sound with this',
      time,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'water_reminders_silent',
          'Water Reminders (Silent)',
          importance: Importance.low,
          priority: Priority.low,
          playSound: false,
          enableVibration: false,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleTestTiming() async {
    final now = tz.TZDateTime.now(tz.local);
    final time = now.add(const Duration(seconds: 30));
    await _plugin.zonedSchedule(
      996,
      'Test — exact timing ⏱',
      'Scheduled at ${now.hour}:${now.minute}:${now.second}'
          ' — fired 30s later. Lock screen to verify.',
      time,
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
