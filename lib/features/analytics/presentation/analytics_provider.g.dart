// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$analyticsRepositoryHash() =>
    r'426a7814826575e0caa7587cbe0d9cef2f15c99f';

/// See also [analyticsRepository].
@ProviderFor(analyticsRepository)
final analyticsRepositoryProvider =
    AutoDisposeProvider<AnalyticsRepository>.internal(
      analyticsRepository,
      name: r'analyticsRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$analyticsRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyticsRepositoryRef = AutoDisposeProviderRef<AnalyticsRepository>;
String _$analyticsSummaryHash() => r'6d5d56e22a601331e43af1194bcc2e27db062a86';

/// See also [analyticsSummary].
@ProviderFor(analyticsSummary)
final analyticsSummaryProvider =
    AutoDisposeFutureProvider<AnalyticsSummary>.internal(
      analyticsSummary,
      name: r'analyticsSummaryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$analyticsSummaryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AnalyticsSummaryRef = AutoDisposeFutureProviderRef<AnalyticsSummary>;
String _$selectedAnalyticsPeriodHash() =>
    r'722ee30738c8f0aaa73fa9b6595a2bb2d85b180f';

/// See also [SelectedAnalyticsPeriod].
@ProviderFor(SelectedAnalyticsPeriod)
final selectedAnalyticsPeriodProvider =
    AutoDisposeNotifierProvider<
      SelectedAnalyticsPeriod,
      AnalyticsPeriod
    >.internal(
      SelectedAnalyticsPeriod.new,
      name: r'selectedAnalyticsPeriodProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedAnalyticsPeriodHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedAnalyticsPeriod = AutoDisposeNotifier<AnalyticsPeriod>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
