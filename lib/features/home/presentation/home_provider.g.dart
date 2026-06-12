// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeRepositoryHash() => r'c3978f1ff54b7b39bb3c4868c9205018f16e6ef2';

/// See also [homeRepository].
@ProviderFor(homeRepository)
final homeRepositoryProvider = AutoDisposeProvider<HomeRepository>.internal(
  homeRepository,
  name: r'homeRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HomeRepositoryRef = AutoDisposeProviderRef<HomeRepository>;
String _$userProfileHash() => r'd31ae7e09693d3a927ef04cbe9f1e6571592fc79';

/// See also [userProfile].
@ProviderFor(userProfile)
final userProfileProvider =
    AutoDisposeFutureProvider<UserProfileModel?>.internal(
      userProfile,
      name: r'userProfileProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$userProfileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserProfileRef = AutoDisposeFutureProviderRef<UserProfileModel?>;
String _$drinkTypesHash() => r'5e609a84f428212b420681865b2d4fe5319b0f36';

/// See also [drinkTypes].
@ProviderFor(drinkTypes)
final drinkTypesProvider =
    AutoDisposeStreamProvider<List<DrinkTypeModel>>.internal(
      drinkTypes,
      name: r'drinkTypesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$drinkTypesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DrinkTypesRef = AutoDisposeStreamProviderRef<List<DrinkTypeModel>>;
String _$todayTotalMlHash() => r'2c849580951e2c78cd80bc011fd62309e9525464';

/// See also [todayTotalMl].
@ProviderFor(todayTotalMl)
final todayTotalMlProvider = AutoDisposeStreamProvider<double>.internal(
  todayTotalMl,
  name: r'todayTotalMlProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todayTotalMlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayTotalMlRef = AutoDisposeStreamProviderRef<double>;
String _$lastLogHash() => r'6b543c20d43b9aa4a9f52b377283d82d00a9993c';

/// See also [lastLog].
@ProviderFor(lastLog)
final lastLogProvider = AutoDisposeFutureProvider<WaterLogModel?>.internal(
  lastLog,
  name: r'lastLogProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastLogHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LastLogRef = AutoDisposeFutureProviderRef<WaterLogModel?>;
String _$todaySummaryHash() => r'cddebeb4a1aeae7538310353b119d00eb2b3d14f';

/// See also [todaySummary].
@ProviderFor(todaySummary)
final todaySummaryProvider = AutoDisposeFutureProvider<TodaySummary>.internal(
  todaySummary,
  name: r'todaySummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$todaySummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodaySummaryRef = AutoDisposeFutureProviderRef<TodaySummary>;
String _$appUnitHash() => r'006177039551f0ba757f995fa3b9ba2816c79cf6';

/// See also [appUnit].
@ProviderFor(appUnit)
final appUnitProvider = AutoDisposeFutureProvider<String>.internal(
  appUnit,
  name: r'appUnitProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appUnitHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppUnitRef = AutoDisposeFutureProviderRef<String>;
String _$todayOverrideNotifierHash() =>
    r'8d2c80cf5aee122ec3ad698274253aeab179b64b';

/// See also [TodayOverrideNotifier].
@ProviderFor(TodayOverrideNotifier)
final todayOverrideNotifierProvider =
    AutoDisposeNotifierProvider<TodayOverrideNotifier, TodayOverride?>.internal(
      TodayOverrideNotifier.new,
      name: r'todayOverrideNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayOverrideNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TodayOverrideNotifier = AutoDisposeNotifier<TodayOverride?>;
String _$homeActionHash() => r'4f8bbca5954aaab51545398aaecd926546b908ae';

/// See also [HomeAction].
@ProviderFor(HomeAction)
final homeActionProvider =
    AutoDisposeNotifierProvider<HomeAction, void>.internal(
      HomeAction.new,
      name: r'homeActionProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$homeActionHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$HomeAction = AutoDisposeNotifier<void>;
String _$jumboTapAmountHash() => r'efd21163d77c8950c1cf20b59f5eedf76bcb338c';

/// See also [JumboTapAmount].
@ProviderFor(JumboTapAmount)
final jumboTapAmountProvider =
    AutoDisposeAsyncNotifierProvider<JumboTapAmount, int>.internal(
      JumboTapAmount.new,
      name: r'jumboTapAmountProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$jumboTapAmountHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$JumboTapAmount = AutoDisposeAsyncNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
