import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../home/presentation/home_provider.dart';
import '../data/notification_service.dart';

part 'reminders_provider.g.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

@riverpod
class NotificationSetupNotifier extends _$NotificationSetupNotifier {
  @override
  Future<bool> build() async {
    final service = ref.read(notificationServiceProvider);
    final granted = await service.requestPermissions();

    if (granted) {
      final profile = await ref.read(userProfileProvider.future);
      if (profile != null) {
        final prefs = await SharedPreferences.getInstance();
        final currentTotal = prefs.getInt('today_total_ml_cache') ?? 0;
        await service.scheduleRemindersForToday(
          wakeHour: profile.wakeHour,
          wakeMinute: profile.wakeMinute,
          sleepHour: profile.sleepHour,
          sleepMinute: profile.sleepMinute,
          intervalMinutes: profile.reminderIntervalMinutes,
          currentTotalMl: currentTotal,
          goalMl: profile.dailyGoalMl,
          notificationsEnabled: profile.notificationsEnabled,
        );
      }
    }

    return granted;
  }
}
