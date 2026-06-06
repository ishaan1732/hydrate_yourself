import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/constants/app_constants.dart';
import '../../../database/database_provider.dart';
import '../../reminders/data/notification_service.dart';
import '../data/home_repository.dart';
import '../domain/drink_type_model.dart';
import '../domain/today_summary.dart';
import '../../onboarding/domain/user_profile_model.dart';

part 'home_provider.g.dart';

@riverpod
HomeRepository homeRepository(Ref ref) => HomeRepository(
      ref.watch(waterLogsDaoProvider),
      ref.watch(userProfileDaoProvider),
      ref.watch(drinkTypesDaoProvider),
    );

@riverpod
Future<UserProfileModel?> userProfile(Ref ref) =>
    ref.watch(homeRepositoryProvider).getProfile();

@riverpod
Stream<List<DrinkTypeModel>> drinkTypes(Ref ref) =>
    ref.watch(homeRepositoryProvider).watchDrinkTypes();

@riverpod
Stream<double> todayTotalMl(Ref ref) =>
    ref.watch(homeRepositoryProvider).watchTodayTotalMl();

final selectedDrinkTypeIdProvider = StateProvider<int?>((ref) => null);

@riverpod
Future<TodaySummary> todaySummary(Ref ref) async {
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
  }
}
