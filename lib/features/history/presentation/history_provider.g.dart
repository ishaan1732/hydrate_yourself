// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$historyRepositoryHash() => r'c8de983d2dc2de0c9b4d8527a5ffa076179acd39';

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
String _$weeklySummariesHash() => r'eb1fb0618923dd25a61e1f267654230e6fc88815';

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
String _$currentStreakHash() => r'd8516d8dc4f5512cdda96f74b467de9a6c9ef47d';

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
String _$selectedDateLogsHash() => r'e3387aec870ba69877f1105493ca8be19169d5e7';

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
