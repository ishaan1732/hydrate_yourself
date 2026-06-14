import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../database/database_provider.dart';
import '../data/analytics_repository.dart';
import '../domain/analytics_models.dart';
import '../domain/analytics_period.dart';

part 'analytics_provider.g.dart';

@riverpod
AnalyticsRepository analyticsRepository(AnalyticsRepositoryRef ref) =>
    AnalyticsRepository(
      ref.watch(waterLogsDaoProvider),
      ref.watch(drinkTypesDaoProvider),
      ref.watch(userProfileDaoProvider),
    );

@riverpod
class SelectedAnalyticsPeriod extends _$SelectedAnalyticsPeriod {
  @override
  AnalyticsPeriod build() => AnalyticsPeriod.month;
  void setPeriod(AnalyticsPeriod p) => state = p;
}

@riverpod
Future<AnalyticsSummary> analyticsSummary(AnalyticsSummaryRef ref) {
  final period = ref.watch(selectedAnalyticsPeriodProvider);
  return ref.watch(analyticsRepositoryProvider).getAnalyticsSummary(period);
}
