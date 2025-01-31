// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getStoriesHash() => r'4252940d31aa40f769ed522773cdf01170b00250';

/// See also [getStories].
@ProviderFor(getStories)
final getStoriesProvider = AutoDisposeFutureProvider<List<StoryModel>>.internal(
  getStories,
  name: r'getStoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$getStoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetStoriesRef = AutoDisposeFutureProviderRef<List<StoryModel>>;
String _$storyViewModelHash() => r'eef690d8f916d0d8d4c043bdd89342b63ffdf8d4';

/// See also [StoryViewModel].
@ProviderFor(StoryViewModel)
final storyViewModelProvider =
    AutoDisposeNotifierProvider<StoryViewModel, AsyncValue?>.internal(
  StoryViewModel.new,
  name: r'storyViewModelProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$storyViewModelHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StoryViewModel = AutoDisposeNotifier<AsyncValue?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
