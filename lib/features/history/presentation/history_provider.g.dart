// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$historyRepositoryHash() => r'4bd62b85eae898f68c5d47e880f7b762b79a4542';

/// See also [historyRepository].
@ProviderFor(historyRepository)
final historyRepositoryProvider =
    AutoDisposeProvider<HistoryRepository>.internal(
      historyRepository,
      name: r'historyRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$historyRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HistoryRepositoryRef = AutoDisposeProviderRef<HistoryRepository>;
String _$weeklySummariesHash() => r'2e995a5573c7d39827a41b9238573da06017b239';

/// See also [weeklySummaries].
@ProviderFor(weeklySummaries)
final weeklySummariesProvider =
    AutoDisposeFutureProvider<List<DailySummary>>.internal(
      weeklySummaries,
      name: r'weeklySummariesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$weeklySummariesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WeeklySummariesRef = AutoDisposeFutureProviderRef<List<DailySummary>>;
String _$currentStreakHash() => r'a5e857f784364a9c8c6921626b926579df007a30';

/// See also [currentStreak].
@ProviderFor(currentStreak)
final currentStreakProvider = AutoDisposeFutureProvider<int>.internal(
  currentStreak,
  name: r'currentStreakProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentStreakHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentStreakRef = AutoDisposeFutureProviderRef<int>;
String _$selectedDateLogsHash() => r'6505f7b779a6f8add97d197199a121a41179c2a6';

/// See also [selectedDateLogs].
@ProviderFor(selectedDateLogs)
final selectedDateLogsProvider =
    AutoDisposeFutureProvider<List<WaterLogModel>>.internal(
      selectedDateLogs,
      name: r'selectedDateLogsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedDateLogsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedDateLogsRef = AutoDisposeFutureProviderRef<List<WaterLogModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
