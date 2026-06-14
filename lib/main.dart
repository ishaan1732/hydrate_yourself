import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'core/constants/app_constants.dart';
import 'core/providers/theme_mode_provider.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/onboarding_provider.dart';
import 'features/reminders/data/notification_service.dart';
import 'features/settings/presentation/settings_provider.dart';

/// Runs in a separate isolate when the user taps the "Drink 250ml" action
/// button on a scheduled reminder notification while the app is in the
/// background or terminated.
///
/// Must live in main.dart — same compilation unit as main() — so the Dart VM
/// kernel snapshot always includes it. No UI, no Drift, no Riverpod — only
/// SharedPreferences. Pending logs are flushed to Drift by
/// [_syncPendingBackgroundLogs] in HomeScreen when the app next resumes.
@pragma('vm:entry-point')
void notificationBackgroundHandler(NotificationResponse response) async {
  debugPrint('=== BG HANDLER FIRED: ${response.actionId} ===');
  debugPrint('=== notificationId: ${response.id} ===');

  if (response.actionId != 'DRINK_250ML') {
    debugPrint('=== BG HANDLER: wrong actionId, returning ===');
    return;
  }

  debugPrint('=== BG HANDLER: initialising SharedPreferences ===');
  final prefs = await SharedPreferences.getInstance();

  final currentTotal = prefs.getInt('today_total_ml_cache') ?? 0;
  debugPrint('=== BG HANDLER: current total = $currentTotal ===');

  const logAmount = 250;
  final newTotal = currentTotal + logAmount;
  await prefs.setInt('today_total_ml_cache', newTotal);
  debugPrint('=== BG HANDLER: new total = $newTotal ===');

  // Format: 'amountMl,timestampMs,drinkTypeId'
  final pending = prefs.getStringList('pending_bg_logs') ?? [];
  final entry = '$logAmount,${DateTime.now().millisecondsSinceEpoch},1';
  pending.add(entry);
  await prefs.setStringList('pending_bg_logs', pending);
  debugPrint('=== BG HANDLER: pending logs = $pending ===');
  debugPrint('=== BG HANDLER: COMPLETE ===');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Timezone initialisation required for zonedSchedule
  tz.initializeTimeZones();
  final tzInfo = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(tzInfo.identifier));

  await NotificationService().initialize(
    onBackground: notificationBackgroundHandler,
  );

  // Request exact alarm permission if not already granted (Android 12+)
  await NotificationService().requestExactAlarmPermissionIfNeeded();

  final prefs = await SharedPreferences.getInstance();
  final isOnboarded =
      prefs.getBool(AppConstants.prefHasCompletedOnboarding) ?? false;

  // Clear stale today-only overrides from a previous day
  final now = DateTime.now();
  final today = '${now.year}-${now.month}-${now.day}';
  if ((prefs.getString('override_date') ?? today) != today) {
    await prefs.remove('override_climate');
    await prefs.remove('override_activity');
    await prefs.remove('override_date');
  }

  runApp(
    ProviderScope(
      overrides: [
        onboardingCompleteProvider.overrideWith((ref) => isOnboarded),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const HydrateApp(),
    ),
  );
}

class HydrateApp extends ConsumerWidget {
  const HydrateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeNotifierProvider);
    return MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
    );
  }
}
