import 'package:drift/drift.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../database/app_database.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  NotificationService._internal();
  factory NotificationService() => instance;

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        // Deep link handled in main.dart — nothing needed here
      },
      onDidReceiveBackgroundNotificationResponse: onNotificationTapBackground,
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      description: AppConstants.notificationChannelDesc,
      importance: Importance.high,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidNotificationChannel progressChannel =
        AndroidNotificationChannel(
      AppConstants.progressChannelId,
      AppConstants.progressChannelName,
      description: AppConstants.progressChannelDesc,
      importance: Importance.low,
      playSound: false,
      enableVibration: false,
      showBadge: false,
    );
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(progressChannel);
  }

  Future<bool> requestPermissions() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      final result = await Permission.notification.request();
      return result.isGranted;
    }
    return status.isGranted;
  }

  Future<void> showReminderNotification() async {
    final messages = [
      'Time to hydrate! 💧 Your body needs water.',
      'Don\'t forget to drink water! 💦',
      'Hydration check! Have you had water recently? 🚰',
      'Your body is 60% water — keep it that way! 💧',
      'Small sips, big difference. Time to drink! 🥤',
    ];

    final index = DateTime.now().millisecond % messages.length;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      AppConstants.notificationChannelId,
      AppConstants.notificationChannelName,
      channelDescription: AppConstants.notificationChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    await _plugin.show(
      AppConstants.notificationId,
      'Hydrate Yourself',
      messages[index],
      const NotificationDetails(android: androidDetails),
      payload: '/home',
    );
  }

  Future<void> showProgressNotification({
    required int totalMl,
    required int goalMl,
    required String unit,
    required int cupSizeMl,
  }) async {
    final percentage = ((totalMl / goalMl) * 100).clamp(0, 100).round();

    final totalStr = unit == 'oz'
        ? '${(totalMl * 0.033814).toStringAsFixed(1)}oz'
        : totalMl >= 1000
            ? '${(totalMl / 1000).toStringAsFixed(1)}L'
            : '${totalMl}ml';

    final goalStr = unit == 'oz'
        ? '${(goalMl * 0.033814).toStringAsFixed(1)}oz'
        : goalMl >= 1000
            ? '${(goalMl / 1000).toStringAsFixed(1)}L'
            : '${goalMl}ml';

    final cupStr = unit == 'oz'
        ? '${(cupSizeMl * 0.033814).toStringAsFixed(1)}oz'
        : '${cupSizeMl}ml';

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      AppConstants.progressChannelId,
      AppConstants.progressChannelName,
      channelDescription: AppConstants.progressChannelDesc,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      showProgress: true,
      maxProgress: goalMl,
      progress: totalMl.clamp(0, goalMl),
      icon: '@mipmap/ic_launcher',
      playSound: false,
      enableVibration: false,
      styleInformation: BigTextStyleInformation(
        '$totalStr of $goalStr · $percentage%',
      ),
      subText: 'Tap to log +$cupStr',
    );

    await _plugin.show(
      AppConstants.progressNotificationId,
      '💧 Hydrate Yourself',
      '$totalStr of $goalStr · $percentage%',
      NotificationDetails(android: androidDetails),
      payload: 'log_water',
    );
  }

  Future<void> dismissProgressNotification() async {
    await _plugin.cancel(AppConstants.progressNotificationId);
  }

  Future<void> updateLastLogTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      AppConstants.prefLastNotificationTime,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<bool> shouldShowReminder(int intervalMinutes) async {
    final prefs = await SharedPreferences.getInstance();
    final lastLogMs = prefs.getInt(AppConstants.prefLastNotificationTime);
    if (lastLogMs == null) return true;
    final lastLog = DateTime.fromMillisecondsSinceEpoch(lastLogMs);
    final diff = DateTime.now().difference(lastLog);
    return diff.inMinutes >= intervalMinutes;
  }
}

@pragma('vm:entry-point')
Future<void> onNotificationTapBackground(
    NotificationResponse response) async {
  if (response.payload != 'log_water') return;

  try {
    WidgetsFlutterBinding.ensureInitialized();

    final prefs = await SharedPreferences.getInstance();
    final cupSizeMl = prefs.getInt(AppConstants.prefLastCupSizeMl) ?? 250;
    final drinkTypeId = prefs.getInt(AppConstants.prefLastDrinkTypeId) ?? 1;
    final goalMl = prefs.getInt(AppConstants.prefTodayGoalMl) ??
        AppConstants.defaultDailyGoalMl;
    final unit =
        prefs.getString(AppConstants.prefSelectedUnit) ?? AppConstants.unitMl;

    final db = AppDatabase();
    await db.waterLogsDao.insertLog(
      WaterLogsCompanion.insert(
        loggedAt: DateTime.now(),
        amountMl: cupSizeMl.toDouble(),
        drinkTypeId: drinkTypeId,
        note: const Value(null),
      ),
    );

    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final logs = await (db.select(db.waterLogs)
          ..where((l) => l.loggedAt.isBetweenValues(start, end)))
        .get();

    final newTotal = logs.fold(0.0, (sum, l) => sum + l.amountMl);
    await db.close();

    await NotificationService().showProgressNotification(
      totalMl: newTotal.round(),
      goalMl: goalMl,
      unit: unit,
      cupSizeMl: cupSizeMl,
    );

    await prefs.setInt(
      AppConstants.prefLastNotificationTime,
      DateTime.now().millisecondsSinceEpoch,
    );
  } catch (e) {
    debugPrint('Background log error: $e');
  }
}
