import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'database/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // TEMPORARY - REMOVE AFTER VERIFICATION
  final db = AppDatabase();
  final drinkTypes = await db.drinkTypesDao.getAllDrinkTypes();
  debugPrint('=== DB SEED VERIFICATION ===');
  for (final dt in drinkTypes) {
    debugPrint(
        'DrinkType: ${dt.name} | coeff: ${dt.hydrationCoefficient} | icon: ${dt.iconName}');
  }
  debugPrint(
      '=== END VERIFICATION: ${drinkTypes.length} drink types found ===');
  await db.close();
  // END TEMPORARY

  runApp(const ProviderScope(child: HydrateApp()));
}

class HydrateApp extends ConsumerWidget {
  const HydrateApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    return MaterialApp.router(
      routerConfig: router,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}
