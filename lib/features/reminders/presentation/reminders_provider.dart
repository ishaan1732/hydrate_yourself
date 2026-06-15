import 'package:riverpod_annotation/riverpod_annotation.dart';

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
        await service.scheduleRemindersForToday(
          wakeHour: profile.wakeHour,
          wakeMinute: profile.wakeMinute,
          sleepHour: profile.sleepHour,
          sleepMinute: profile.sleepMinute,
          intervalMinutes: profile.reminderIntervalMinutes,
          currentTotalMl: 0,
          goalMl: profile.dailyGoalMl,
          notificationsEnabled: profile.notificationsEnabled,
        );
      }
    }

    return granted;
  }
}
