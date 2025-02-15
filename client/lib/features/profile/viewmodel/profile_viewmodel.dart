import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/profile/repository/profile_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_viewmodel.g.dart';

@riverpod
Future<Map<String, int>> getPostsCounts(GetPostsCountsRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final userId =
      ref.watch(currentUserNotifierProvider.select((user) => user!.id));

  final res = await ref.read(profileRepositoryProvider).getPostsCounts(
        token: token,
        userId: userId,
      );

  return res.fold(
    (failure) => throw failure.message, // Throws error properly
    (posts) => posts, // Returns the correct data
  );
}

@riverpod
Future<List<UserModel>> getUser(GetUserRef ref) async {
  final token =
      ref.watch(currentUserNotifierProvider.select((user) => user!.token));
  final res = await ref.watch(profileRepositoryProvider).getUser(
        token: token,
      );

  return res.fold(
    (failure) => throw failure.message, // Throws error properly
    (profile) => profile, // Returns the correct data
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

  Future<void> editUser({
    required String selectedProfileImage,
    required String bio,
    required String id,
    required String userName,
  }) async {
    state = const AsyncValue.loading();
    await _profileRepository.editUser(
      uid: id,
      selectedProfileImage: selectedProfileImage,
      userName: userName,
      bio: bio,
      token: ref.read(currentUserNotifierProvider)!.token,
    );
  }
}
