import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../data/background_task.dart';
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
    await service.initialize();
    final granted = await service.requestPermissions();

    if (granted) {
      final prefs = await SharedPreferences.getInstance();
      final interval = prefs.getInt('reminder_interval_minutes') ??
          AppConstants.defaultReminderIntervalMinutes;
      await BackgroundTaskManager.scheduleReminders(interval);
    }

    return granted;
  }
}
