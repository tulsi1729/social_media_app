import 'dart:developer';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/profile/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

@riverpod
Future<Map<String, int>> getFollowCount(GetFollowCountRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final userId =
      ref.watch(currentUserNotifierProvider.select((user) => user!.id));

  final res = await ref.read(profileRepositoryProvider).getFollowCounts(
        token: token,
        userId: userId,
      );

  return res.fold(
    (failure) => throw failure.message, // Throws error properly
    (follows) => follows, // Returns the correct data
  );
}

@riverpod
class ProfileViewModel extends _$ProfileViewModel {
  late ProfileRepository _profileRepository;

  @override
  AsyncValue? build() {
    _profileRepository = ref.watch(profileRepositoryProvider);
    return null;
  }

  Future<void> followUser({
    required String targetUserId,
  }) async {
    state = const AsyncValue.loading();
    final res = await _profileRepository.followUser(
      targetUserId: targetUserId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    log(res.toString(), name: "model create profile ");
  }

  Future<void> unFollowUser({
    required String targetUserId,
  }) async {
    state = const AsyncValue.loading();
    await _profileRepository.unFollowUser(
      targetUserId: targetUserId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );
  }
}
