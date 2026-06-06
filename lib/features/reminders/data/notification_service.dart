import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        // Deep link handled in main.dart — nothing needed here
      },
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
