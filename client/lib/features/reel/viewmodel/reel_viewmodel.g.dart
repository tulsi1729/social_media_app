// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reel_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getReelsHash() => r'7d677791e86d7e34022b07a4204651dbbd77124b';

/// See also [getReels].
@ProviderFor(getReels)
final getReelsProvider = AutoDisposeFutureProvider<List<ReelModel>>.internal(
  getReels,
  name: r'getReelsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getReelsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetReelsRef = AutoDisposeFutureProviderRef<List<ReelModel>>;
String _$reelViewModelHash() => r'f4c8200a442bfc47703ce5e56a2cbe45ec4eefc3';

/// See also [ReelViewModel].
@ProviderFor(ReelViewModel)
final reelViewModelProvider =
    AutoDisposeNotifierProvider<ReelViewModel, AsyncValue?>.internal(
  ReelViewModel.new,
  name: r'reelViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$reelViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReelViewModel = AutoDisposeNotifier<AsyncValue?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
