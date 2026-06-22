import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

// Fires when a notification is tapped while the app is fully terminated.
// Must be a top-level function (not a class method) since
// @pragma('vm:entry-point') functions cannot be class methods.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse details) {
  // App will be launched by the tap — active notifications will be
  // dismissed by the foreground handler on resume. No additional
  // action needed here for now.
}

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();
  factory NotificationService() => instance;

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _soundChannelId = 'water_reminders_v2';
  static const String _silentChannelId = 'water_reminders_silent';

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const iosSettings = DarwinInitializationSettings();

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) async {
        await dismissActiveNotifications();
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _soundChannelId,
        'Water Reminders',
        description: 'Hydration reminders throughout the day',
        importance: Importance.high,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('water_pour'),
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

  /// Dismisses only the notifications currently visible in the shade.
  /// getActiveNotifications() returns just what's visible right now —
  /// not the future scheduled alarms — so cancelling by id here leaves
  /// the recurring AlarmManager entries completely intact.
  Future<void> dismissActiveNotifications() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    final active = await android.getActiveNotifications();
    for (final notification in active) {
      if (notification.id != null) {
        await _plugin.cancel(notification.id!);
      }
    }
  }

  Future<bool> isExactAlarmPermissionGranted() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await androidPlugin?.canScheduleExactNotifications() ?? false;
  }

  /// Cancels all pending reminders, then registers one notification per
  /// interval slot between wake and sleep, each using
  /// [DateTimeComponents.time] so the OS repeats it at that same
  /// time every day indefinitely. No rolling horizon and no further
  /// Dart-side rescheduling is needed until wake/sleep/interval/sound
  /// actually change.
  Future<void> scheduleReminders({
    required int wakeHour,
    required int wakeMinute,
    required int sleepHour,
    required int sleepMinute,
    required int intervalMinutes,
    required bool notificationsEnabled,
    required bool soundEnabled,
  }) async {
    int notificationId = 100;
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

      // If sleep time, read as a plain time-of-day, falls at or
      // before wake time, the user's bedtime is after midnight
      // relative to their wake time (e.g. wake 6:00am, sleep
      // 12:00am/1:00am/2:00am) — so the sleep boundary belongs
      // to the calendar day AFTER wake's date, not the same one.
      final wakeMinutesOfDay = wakeHour * 60 + wakeMinute;
      final sleepMinutesOfDay = sleepHour * 60 + sleepMinute;
      final sleepCrossesMidnight = sleepMinutesOfDay <= wakeMinutesOfDay;

      // First slot is wake + interval, not wake itself
      var slotTime = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, wakeHour, wakeMinute,
      ).add(Duration(minutes: intervalMinutes));

      final sleepDate = sleepCrossesMidnight
          ? now.add(const Duration(days: 1))
          : now;

      final sleepTime = tz.TZDateTime(
        tz.local, sleepDate.year, sleepDate.month, sleepDate.day,
        sleepHour, sleepMinute,
      );

      // The date part of slotTime only matters for ordering slots
      // against sleepTime below — matchDateTimeComponents.time makes
      // each registration recur daily at this time-of-day, rolling
      // forward to the next occurrence automatically if it's already
      // passed today.
      while (slotTime.isBefore(sleepTime)) {
        await _plugin.zonedSchedule(
          notificationId,
          'Time to hydrate! 💧',
          'Stay on track with your water goal today.',
          slotTime,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channelId,
              channelName,
              channelDescription: 'Hydration reminders throughout the day',
              importance: soundEnabled ? Importance.high : Importance.low,
              priority: soundEnabled ? Priority.high : Priority.low,
              playSound: soundEnabled,
              sound: soundEnabled
                  ? const RawResourceAndroidNotificationSound('water_pour')
                  : null,
              enableVibration: soundEnabled,
              icon: '@mipmap/launcher_icon',
            ),
          ),
          androidScheduleMode: scheduleMode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.time,
        );

        notificationId++;
        slotTime = slotTime.add(Duration(minutes: intervalMinutes));
      }
    } catch (e) {
      debugPrint('Failed to schedule reminders id=$notificationId: $e');
    }
  }

}
