import 'dart:developer';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/home/models/story_model.dart';
import 'package:client/features/story/repository/story_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_viewmodel.g.dart';

@riverpod
Future<List<StoryModel>> getStories(GetStoriesRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(storyRepositoryProvider).getStories(token: token);

  return res.fold(
    (failure) => throw failure.message,
    (stories) => stories,
  );
}

@riverpod
class StoryViewModel extends _$StoryViewModel {
  late StoryRepository _storyRepository;

  @override
  AsyncValue? build() {
    _storyRepository = ref.watch(storyRepositoryProvider);
    return null;
  }

  Future<void> createStory({
    required String selectedImage,
    required String views,
  }) async {
    state = const AsyncValue.loading();
    final res = await _storyRepository.createStory(
      selectedImage: selectedImage,
      token: ref.read(currentUserNotifierProvider)!.token,
      views: views,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }
}
