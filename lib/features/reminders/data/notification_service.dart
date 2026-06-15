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

        scheduledTime = scheduledTime.add(Duration(minutes: intervalMinutes));
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
