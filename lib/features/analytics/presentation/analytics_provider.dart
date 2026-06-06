import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../database/database_provider.dart';
import '../data/analytics_repository.dart';
import '../domain/analytics_models.dart';

part 'analytics_provider.g.dart';

@riverpod
AnalyticsRepository analyticsRepository(AnalyticsRepositoryRef ref) => AnalyticsRepository(
      ref.watch(waterLogsDaoProvider),
      ref.watch(drinkTypesDaoProvider),
      ref.watch(userProfileDaoProvider),
    );

@riverpod
Future<AnalyticsSummary> analyticsSummary(AnalyticsSummaryRef ref) =>
    ref.watch(analyticsRepositoryProvider).getAnalyticsSummary();
