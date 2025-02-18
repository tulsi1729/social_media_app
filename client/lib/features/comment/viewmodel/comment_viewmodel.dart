import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/comment/model/comment_model.dart';
import 'package:client/features/comment/repository/comment_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'comment_viewmodel.g.dart';

final commentsProvider =
    FutureProvider.family<List<CommentModel>, String>((ref, postId) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(commentRepositoryProvider).getComments(
        token: token,
        postId: postId,
      );

  return res.fold(
    (failure) => throw failure.message,
    (comments) => comments,
  );
});

final commentCountProvider =
    FutureProvider.family<int, String>((ref, postId) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));

  final res = await ref.read(commentRepositoryProvider).getCommentCount(
        token: token,
        postId: postId,
      );

  return res.fold((failure) => throw failure.message, (data) => data);
});

@riverpod
class CommentViewModel extends _$CommentViewModel {
  late CommentRepository _commentRepository;

  @override
  AsyncValue? build() {
    _commentRepository = ref.watch(commentRepositoryProvider);
    return null;
  }

  Future<void> commentPost({
    required String comment,
    required String postId,
    required DateTime createdOn,
  }) async {
    state = const AsyncValue.loading();

    final userName =
        ref.read(currentUserNotifierProvider.select((user) => user!.name));

    final res = await _commentRepository.commentPost(
      comment: comment,
      postId: postId,
      createdBy: userName,
      createdOn: createdOn,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  Future<void> deleteComment({
    required int commentId,
  }) async {
    state = const AsyncValue.loading();

    await _commentRepository.deleteComment(
      commentId: commentId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    // final val = switch (res) {
    //   Left(value: final l) => state =
    //       AsyncValue.error(l.message, StackTrace.current),
    //   Right(value: final r) => state = AsyncValue.data(r),
    // };
    // print(res);
  }
}
