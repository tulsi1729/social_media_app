// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getPostsHash() => r'8961066514e4a6e0876bdb5d1f5c4fd09463a8ba';

/// See also [getPosts].
@ProviderFor(getPosts)
final getPostsProvider = AutoDisposeFutureProvider<List<PostModel>>.internal(
  getPosts,
  name: r'getPostsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getPostsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetPostsRef = AutoDisposeFutureProviderRef<List<PostModel>>;
String _$getMyPostsHash() => r'64168a386b17f7a4b17774008071b7147bd3f5db';

/// See also [getMyPosts].
@ProviderFor(getMyPosts)
final getMyPostsProvider = AutoDisposeFutureProvider<List<PostModel>>.internal(
  getMyPosts,
  name: r'getMyPostsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getMyPostsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetMyPostsRef = AutoDisposeFutureProviderRef<List<PostModel>>;
String _$homeViewModelHash() => r'934661a35954b5ee28de4ebf2568541f11ba5c31';

/// See also [HomeViewModel].
@ProviderFor(HomeViewModel)
final homeViewModelProvider =
    AutoDisposeNotifierProvider<HomeViewModel, AsyncValue?>.internal(
  HomeViewModel.new,
  name: r'homeViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$homeViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HomeViewModel = AutoDisposeNotifier<AsyncValue?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
