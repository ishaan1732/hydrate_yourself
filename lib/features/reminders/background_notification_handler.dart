import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Runs in a separate isolate when the user taps the "Drink 250ml" action
/// button on a scheduled reminder notification while the app is in the
/// background or terminated.
///
/// No UI, no Drift, no Riverpod — only SharedPreferences.
/// Pending logs are flushed to Drift by [_syncPendingBackgroundLogs] in
/// HomeScreen when the app next resumes.
@pragma('vm:entry-point')
void notificationBackgroundHandler(NotificationResponse response) async {
  if (response.actionId != 'DRINK_250ML') return;

  final prefs = await SharedPreferences.getInstance();

  final currentTotal = prefs.getInt('today_total_ml_cache') ?? 0;
  const logAmount = 250;
  await prefs.setInt('today_total_ml_cache', currentTotal + logAmount);

  // Format: 'amountMl,timestampMs,drinkTypeId'
  final pending = prefs.getStringList('pending_bg_logs') ?? [];
  pending.add('$logAmount,${DateTime.now().millisecondsSinceEpoch},1');
  await prefs.setStringList('pending_bg_logs', pending);
}
