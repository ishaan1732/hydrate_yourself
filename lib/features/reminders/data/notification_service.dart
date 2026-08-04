import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

import '../../../core/constants/app_constants.dart';
import '../../../database/app_database.dart';
import '../../home/presentation/home_provider.dart';

// Fires when a notification is tapped while the app is fully terminated OR
// backgrounded. Must be a top-level function (not a class method) since
// @pragma('vm:entry-point') functions cannot be class methods.
//
// Only the 'add_water' action (from the persistent progress notification)
// does anything here. It reads the db path cached by
// NotificationService.cacheDbPath() at foreground startup instead of
// resolving it via path_provider — path_provider doesn't reliably resolve
// from this isolate on real devices, which is what broke a previous
// attempt at this feature.
//
// This isolate DOES also refresh the persistent notification's text after
// writing (a deliberate reversal of the original v1 scope, which avoided
// exactly this second DB read + notification update from here). It's safe
// because the read reuses the SAME AppDatabase instance that just wrote —
// Drift's stream reactivity is scoped to the connection instance, so this
// isn't crossing the isolate boundary the way the *foreground* app's
// streams would need to (see home_screen.dart's didChangeAppLifecycleState
// for that side of it).
@pragma('vm:entry-point')
Future<void> notificationTapBackground(NotificationResponse response) async {
  debugPrint('=== BACKGROUND_ISOLATE_FIRED === '
      'actionId=${response.actionId}');
  if (response.actionId != AppConstants.persistentNotificationAddAction) {
    // App will be launched by the tap — active notifications will be
    // dismissed by the foreground handler on resume. No additional
    // action needed here for now.
    return;
  }

  try {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();

    final prefs = await SharedPreferences.getInstance();

    // Read the path cached from the foreground — never resolve it via
    // path_provider from this isolate.
    final dbPath = prefs.getString(AppConstants.prefCachedDbPath);
    if (dbPath == null) return;

    final cupSizeMl = prefs.getInt(AppConstants.prefLastCupSizeMl) ?? 250;
    final drinkTypeId = prefs.getInt(AppConstants.prefLastDrinkTypeId) ?? 1;

    final db = AppDatabase.openWithPath(dbPath);
    double newTotalMl;
    try {
      debugPrint('=== BACKGROUND_DB_WRITE_ATTEMPT === '
          'cupSizeMl=$cupSizeMl dbPath=$dbPath');
      await db.waterLogsDao.insertLog(WaterLogsCompanion.insert(
        loggedAt: DateTime.now(),
        amountMl: cupSizeMl.toDouble(),
        drinkTypeId: drinkTypeId,
      ));
      debugPrint('=== BACKGROUND_DB_WRITE_SUCCESS ===');
      // Same connection instance that just wrote — this read sees the
      // insert above without needing a fresh subscription.
      newTotalMl = await db.waterLogsDao.watchTodayTotalMl().first;
    } finally {
      await db.close();
    }

    debugPrint('Background water log: ${cupSizeMl}ml');

    final notificationEnabled =
        prefs.getBool(AppConstants.prefPersistentNotificationEnabled) ??
            false;
    if (notificationEnabled) {
      final goalMl = prefs.getInt(AppConstants.prefTodayGoalMl) ??
          AppConstants.defaultDailyGoalMl;
      final unit =
          prefs.getString(AppConstants.prefSelectedUnit) ?? AppConstants.unitMl;
      await NotificationService().showPersistentNotification(
        currentMl: newTotalMl.round(),
        goalMl: goalMl,
        cupSizeMl: cupSizeMl,
        unit: unit,
      );
    }
  } catch (e) {
    debugPrint('Background tap failed: $e');
  }
}

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();
  factory NotificationService() => instance;

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _soundChannelId = 'water_reminders_v2';
  static const String _silentChannelId = 'water_reminders_silent';

  /// Set once from main.dart. Lets the foreground notification response
  /// handler below invalidate Home's providers after a DB write it makes
  /// itself — that write goes through a separate AppDatabase connection
  /// (see the handler), so Riverpod has no other way to know about it.
  static ProviderContainer? providerContainer;

  /// Called once at app startup from the foreground. Stores the resolved
  /// database path so the background isolate can open the SAME file via
  /// [AppDatabase.openWithPath] without calling path_provider itself (see
  /// [notificationTapBackground]).
  static Future<void> cacheDbPath() async {
    final dbPath = await AppDatabase.resolveDbPath();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefCachedDbPath, dbPath);
  }

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
        if (details.actionId != AppConstants.persistentNotificationAddAction) {
          await dismissActiveNotifications();
          return;
        }

        // App is already running — this is the SAME isolate as the rest
        // of the app, unlike notificationTapBackground. Still goes
        // through a separate AppDatabase connection rather than the
        // app-wide Riverpod one (NotificationService is a bare singleton
        // with no ref of its own), so Home's streams won't see this write
        // on their own — hence the providerContainer.invalidate calls
        // below.
        final prefs = await SharedPreferences.getInstance();
        final cupSizeMl = prefs.getInt(AppConstants.prefLastCupSizeMl) ?? 250;
        final drinkTypeId =
            prefs.getInt(AppConstants.prefLastDrinkTypeId) ?? 1;
        final dbPath = prefs.getString(AppConstants.prefCachedDbPath);
        if (dbPath == null) return;

        final db = AppDatabase.openWithPath(dbPath);
        double newTotalMl;
        try {
          await db.waterLogsDao.insertLog(WaterLogsCompanion.insert(
            loggedAt: DateTime.now(),
            amountMl: cupSizeMl.toDouble(),
            drinkTypeId: drinkTypeId,
          ));
          newTotalMl = await db.waterLogsDao.watchTodayTotalMl().first;
        } finally {
          await db.close();
        }

        providerContainer?.invalidate(todayTotalMlProvider);
        providerContainer?.invalidate(todaySummaryProvider);

        final notificationEnabled = prefs.getBool(
                AppConstants.prefPersistentNotificationEnabled) ??
            false;
        if (notificationEnabled) {
          final goalMl = prefs.getInt(AppConstants.prefTodayGoalMl) ??
              AppConstants.defaultDailyGoalMl;
          final unit = prefs.getString(AppConstants.prefSelectedUnit) ??
              AppConstants.unitMl;
          await showPersistentNotification(
            currentMl: newTotalMl.round(),
            goalMl: goalMl,
            cupSizeMl: cupSizeMl,
            unit: unit,
          );
        }
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
    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        AppConstants.progressChannelId,
        AppConstants.progressChannelName,
        description: AppConstants.progressChannelDesc,
        importance: Importance.low,
        playSound: false,
        enableVibration: false,
        showBadge: false,
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
  ///
  /// The persistent progress notification (id [AppConstants.
  /// progressNotificationId]) is excluded: it's `ongoing: true` and meant
  /// to stay visible across app opens, so a blanket sweep of "everything
  /// currently in the shade" must not cancel it too.
  Future<void> dismissActiveNotifications() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    final active = await android.getActiveNotifications();
    for (final notification in active) {
      if (notification.id != null &&
          notification.id != AppConstants.progressNotificationId) {
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

  /// Shows (or updates) the persistent hydration-progress notification.
  /// Called from the foreground on every summary change (see
  /// home_screen.dart), from the Settings toggle, and from the background
  /// isolate itself right after an "Add water" tap writes a log (see
  /// [notificationTapBackground]) so the total shown doesn't go stale
  /// until the app is next opened.
  Future<void> showPersistentNotification({
    required int currentMl,
    required int goalMl,
    required int cupSizeMl,
    required String unit,
  }) async {
    final isOz = unit == AppConstants.unitOz;
    final displayCurrent = isOz ? (currentMl / 29.5735).round() : currentMl;
    final displayGoal = isOz ? (goalMl / 29.5735).round() : goalMl;
    final displayCup = isOz
        ? '${(cupSizeMl / 29.5735).toStringAsFixed(1)} oz'
        : '$cupSizeMl ml';
    final unitLabel = isOz ? 'oz' : 'ml';
    final percentage = ((currentMl / goalMl) * 100).clamp(0, 100).round();

    const addAction = AndroidNotificationAction(
      AppConstants.persistentNotificationAddAction,
      'Add water',
      showsUserInterface: false,
      cancelNotification: false,
    );

    final androidDetails = AndroidNotificationDetails(
      AppConstants.progressChannelId,
      AppConstants.progressChannelName,
      channelDescription: AppConstants.progressChannelDesc,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      playSound: false,
      enableVibration: false,
      showProgress: true,
      maxProgress: goalMl,
      progress: currentMl.clamp(0, goalMl).toInt(),
      icon: '@mipmap/launcher_icon',
      actions: const [addAction],
      subText: '$percentage%',
    );

    await _plugin.show(
      AppConstants.progressNotificationId,
      '💧 $displayCurrent / $displayGoal $unitLabel',
      currentMl >= goalMl ? 'Goal reached! 🎉' : 'Tap to add $displayCup',
      NotificationDetails(android: androidDetails),
    );
  }

  Future<void> dismissPersistentNotification() async {
    await _plugin.cancel(AppConstants.progressNotificationId);
  }
}
