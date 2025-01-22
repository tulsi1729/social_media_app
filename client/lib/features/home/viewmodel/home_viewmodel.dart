import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/home/models/post_model.dart';
import 'package:client/features/home/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_viewmodel.g.dart';

@riverpod
Future<List<PostModel>> getPosts(GetPostsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(homeRepositoryProvider).getPosts(
        token: token,
      );

  return res.fold(
    (failure) => throw failure.message,
    (posts) => posts,
  );
}

@riverpod
Future<List<PostModel>> getMyPosts(GetMyPostsRef ref) async {
  final token = ref.watch(
    currentUserNotifierProvider.select((user) => user!.token),
  );

  final res = await ref.watch(homeRepositoryProvider).geMyPosts(
        token: token,
      );

  return res.fold(
    (failure) => throw failure.message,
    (posts) => posts,
  );
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  late HomeRepository _homeRepository;

  @override
  AsyncValue? build() {
    _homeRepository = ref.watch(homeRepositoryProvider);
    return null;
  }

  Future<void> createPost({
    required String caption,
    required String selectedImage,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.createPost(
      caption: caption,
      selectedImage: selectedImage,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  // Future<void> editedPost({
  //   required String caption,
  //   required String postId,
  //   required File selectedPostMedia,
  // }) async {
  //   state = const AsyncValue.loading();
  //   final res = await _homeRepository.editPost(
  //     caption: caption,
  //     postId: postId,
  //     token: ref.read(currentUserNotifierProvider)!.token,
  //   );

  //   final val = switch (res) {
  //     Left(value: final l) => state =
  //         AsyncValue.error(l.message, StackTrace.current),
  //     Right(value: final r) => state = AsyncValue.data(r),
  //   };

  //   print(val);
  // }

  Future<void> deletedPost({
    required String postId,
    required String token,
  }) async {
    state = const AsyncValue.loading();
    final res = await _homeRepository.deletePost(
      postId: postId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    return res;
  }

  Future<void> likePost({
    required String postId,
  }) async {
    state = const AsyncValue.loading();

    final uid =
        ref.read(currentUserNotifierProvider.select((user) => user!.id));

    final res = await _homeRepository.likePost(
      postId: postId,
      uid: uid,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  Future<void> commentPost({
    required String postId,
    required String comment,
    required DateTime time,
  }) async {
    state = const AsyncValue.loading();

    final uid =
        ref.read(currentUserNotifierProvider.select((user) => user!.id));

    final res = await _homeRepository.commentPost(
      postId: postId,
      uid: uid,
      comment: comment,
      time: time,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }
}
