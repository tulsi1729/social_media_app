// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getPostsCountsHash() => r'5e03966ef860decba60ac047427647db85c3929a';

/// See also [getPostsCounts].
@ProviderFor(getPostsCounts)
final getPostsCountsProvider =
    AutoDisposeFutureProvider<Map<String, int>>.internal(
  getPostsCounts,
  name: r'getPostsCountsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getPostsCountsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetPostsCountsRef = AutoDisposeFutureProviderRef<Map<String, int>>;
String _$getUserHash() => r'e0cda8afd8edfec40e660fa8631998e50d16d01f';

/// See also [getUser].
@ProviderFor(getUser)
final getUserProvider = AutoDisposeFutureProvider<List<UserModel>>.internal(
  getUser,
  name: r'getUserProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetUserRef = AutoDisposeFutureProviderRef<List<UserModel>>;
String _$profileViewModelHash() => r'5cae745f1955f200d7b9c38d758d62780e7310ed';

/// See also [ProfileViewModel].
@ProviderFor(ProfileViewModel)
final profileViewModelProvider =
    AutoDisposeNotifierProvider<ProfileViewModel, AsyncValue?>.internal(
  ProfileViewModel.new,
  name: r'profileViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$profileViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProfileViewModel = AutoDisposeNotifier<AsyncValue?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
