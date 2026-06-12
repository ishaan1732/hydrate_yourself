import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_constants.dart';
import 'core/providers/theme_mode_provider.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/presentation/onboarding_provider.dart';
import 'features/reminders/data/background_task.dart';
import 'features/reminders/data/notification_service.dart';
import 'features/settings/presentation/settings_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BackgroundTaskManager.initialize();
  await NotificationService().initialize();
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
