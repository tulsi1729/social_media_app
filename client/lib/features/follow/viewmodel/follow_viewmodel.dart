
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/follow/repository/follow_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'follow_viewmodel.g.dart';

@riverpod
Future<Map<String, int>> getFollowCount(GetFollowCountRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final userId =
      ref.watch(currentUserNotifierProvider.select((user) => user!.id));

  final res = await ref.read(followRepositoryProvider).getFollowCounts(
        token: token,
        userId: userId,
      );

  return res.fold(
    (failure) => throw failure.message,
    (follows) => follows,
  );
}

@riverpod
class FollowViewModel extends _$FollowViewModel {
  late FollowRepository _followRepository;

  @override
  AsyncValue? build() {
    _followRepository = ref.watch(followRepositoryProvider);
    return null;
  }

  Future<void> followUser({
    required String targetUserId,
  }) async {
    state = const AsyncValue.loading();
    await _followRepository.followUser(
      targetUserId: targetUserId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );
  }

  Future<void> unFollowUser({
    required String targetUserId,
  }) async {
    state = const AsyncValue.loading();
    await _followRepository.unFollowUser(
      targetUserId: targetUserId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );
  }
}
