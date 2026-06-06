// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$homeRepositoryHash() => r'3d370978667260651f1a3cc8621876283d218b7f';

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
String _$userProfileHash() => r'a45ac070fb88b876c7bfe8d8c8b35c53c61e32a5';

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
String _$drinkTypesHash() => r'cd2f3ffa81a61617cda4fe3231cdc7aa4df49258';

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
String _$todayTotalMlHash() => r'e4d4a6d153b4862c421f572f4bac0bb2943823b6';

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
String _$todaySummaryHash() => r'c65d90d05fb2753fccbda16e9ea246e53e22547c';

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
String _$homeActionHash() => r'172680091e5919f8c0683cc13adba9bebb7acc6b';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
