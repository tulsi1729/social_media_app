import 'dart:developer';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/reel/model/reel_model.dart';
import 'package:client/features/reel/repository/reel_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reel_viewmodel.g.dart';

@riverpod
Future<List<ReelModel>> getReels(GetReelsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(reelRepositoryProvider).getReels(
        token: token,
      );

  return res.fold(
    (failure) => throw failure.message,
    (posts) => posts,
  );
}

@riverpod
class ReelViewModel extends _$ReelViewModel {
  late ReelRepository _reelRepository;

  @override
  AsyncValue? build() {
    _reelRepository = ref.watch(reelRepositoryProvider);
    return null;
  }

  Future<void> createReel({
    required String caption,
    required String selectedVideo,
  }) async {
    state = const AsyncValue.loading();
    final res = await _reelRepository.createReel(
      caption: caption,
      selectedVideo: selectedVideo,
      token: ref.read(currentUserNotifierProvider)!.token,
    );

    log(res.toString(), name: "model create home story");

    final val = switch (res) {
      Left(value: final l) => state =
          AsyncValue.error(l.message, StackTrace.current),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }

  Future<void> deletedReel({
    required String reelId,
  }) async {
    state = const AsyncValue.loading();
    final res = await _reelRepository.deleteReel(
      reelId: reelId,
      token: ref.read(currentUserNotifierProvider)!.token,
    );
    return res;
  }
}
