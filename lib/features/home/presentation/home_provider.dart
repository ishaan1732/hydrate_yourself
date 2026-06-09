import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../database/database_provider.dart';
import '../../reminders/data/notification_service.dart';
import '../data/home_repository.dart';
import '../domain/drink_type_model.dart';
import '../domain/today_summary.dart';
import '../domain/water_log_model.dart';
import '../../onboarding/domain/user_profile_model.dart';

part 'home_provider.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) => HomeRepository(
      ref.watch(waterLogsDaoProvider),
      ref.watch(userProfileDaoProvider),
      ref.watch(drinkTypesDaoProvider),
    );

@riverpod
Future<UserProfileModel?> userProfile(UserProfileRef ref) =>
    ref.watch(homeRepositoryProvider).getProfile();

@riverpod
Stream<List<DrinkTypeModel>> drinkTypes(DrinkTypesRef ref) =>
    ref.watch(homeRepositoryProvider).watchDrinkTypes();

@riverpod
Stream<double> todayTotalMl(TodayTotalMlRef ref) =>
    ref.watch(homeRepositoryProvider).watchTodayTotalMl();

final selectedDrinkTypeIdProvider = StateProvider<int?>((ref) => null);

final goalPreviouslyAchievedProvider = StateProvider<bool>((ref) => false);

final showCelebrationProvider = StateProvider<bool>((ref) => false);

@riverpod
Future<WaterLogModel?> lastLog(LastLogRef ref) =>
    ref.watch(homeRepositoryProvider).getLastLog();

@riverpod
Future<TodaySummary> todaySummary(TodaySummaryRef ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  final totalMl = await ref.watch(todayTotalMlProvider.future);
  final goalMl = profile?.dailyGoalMl ?? AppConstants.defaultDailyGoalMl;
  return TodaySummary(
    totalMl: totalMl,
    goalMl: goalMl,
    logs: [],
  );
}

@riverpod
class HomeAction extends _$HomeAction {
  @override
  void build() {}

  Future<void> addQuickLog(double amountMl) async {
    final drinkTypes = await ref.read(drinkTypesProvider.future);
    final selectedId = ref.read(selectedDrinkTypeIdProvider);
    final drinkType = selectedId != null
        ? drinkTypes.firstWhere(
            (d) => d.id == selectedId,
            orElse: () => drinkTypes.first,
          )
        : drinkTypes.first;
    await ref.read(homeRepositoryProvider).addLog(
          amountMl: amountMl,
          drinkTypeId: drinkType.id,
        );
    await NotificationService().updateLastLogTime();

    final summary = await ref.read(todaySummaryProvider.future);
    final wasAlreadyAchieved = ref.read(goalPreviouslyAchievedProvider);

    if (summary.isGoalAchieved && !wasAlreadyAchieved) {
      ref.read(goalPreviouslyAchievedProvider.notifier).state = true;
      ref.read(showCelebrationProvider.notifier).state = true;
      await NotificationService().markGoalAchievedToday();
      Future.delayed(const Duration(seconds: 3), () {
        ref.read(showCelebrationProvider.notifier).state = false;
      });
    }

    ref.invalidate(lastLogProvider);
    await ref.read(jumboTapAmountProvider.notifier).setAmount(amountMl.round());

    // Store context for background notification tap handler
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefLastCupSizeMl, amountMl.round());
    await prefs.setInt(AppConstants.prefLastDrinkTypeId, drinkType.id);
    await prefs.setInt(AppConstants.prefTodayGoalMl, summary.goalMl);

    // Update persistent progress notification
    final profile = ref.read(userProfileProvider).valueOrNull;
    final unit = profile?.unit ?? AppConstants.unitMl;
    await NotificationService().showProgressNotification(
      totalMl: (await ref.read(todayTotalMlProvider.future)).round(),
      goalMl: summary.goalMl,
      unit: unit,
      cupSizeMl: amountMl.round(),
    );
  }

  Future<void> deleteLastLog() async {
    final lastLog = await ref.read(lastLogProvider.future);
    if (lastLog == null) return;

    // Read current total and goal BEFORE deleting
    // so we get accurate values, not stale stream data
    final currentTotal = await ref.read(todayTotalMlProvider.future);
    final summary = await ref.read(todaySummaryProvider.future);

    // Calculate what the total will be after deletion
    final totalAfterUndo = currentTotal - lastLog.amountMl;

    // Delete the log
    await ref.read(homeRepositoryProvider).deleteLog(lastLog.id);
    ref.invalidate(lastLogProvider);

    // If new total drops below goal, reset celebration
    // so it fires again when goal is re-crossed
    if (totalAfterUndo < summary.goalMl) {
      ref.read(goalPreviouslyAchievedProvider.notifier).state = false;
    }

    // Refresh persistent progress notification after undo
    try {
      final profile = ref.read(userProfileProvider).valueOrNull;
      final unit = profile?.unit ?? AppConstants.unitMl;
      final prefs = await SharedPreferences.getInstance();
      final cupSize = prefs.getInt(AppConstants.prefLastCupSizeMl) ?? 250;
      final newTotal = await ref.read(todayTotalMlProvider.future);
      await NotificationService().showProgressNotification(
        totalMl: newTotal.round(),
        goalMl: summary.goalMl,
        unit: unit,
        cupSizeMl: cupSize,
      );
    } catch (_) {}
  }
}

@riverpod
class JumboTapAmount extends _$JumboTapAmount {
  @override
  Future<int> build() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstants.prefLastCupSizeMl) ?? 250;
  }

  Future<void> setAmount(int ml) async {
    state = AsyncData(ml);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.prefLastCupSizeMl, ml);
  }
}

@riverpod
Future<String> appUnit(AppUnitRef ref) async {
  final profile = await ref.watch(userProfileProvider.future);
  return profile?.unit ?? AppConstants.unitMl;
}
