import 'dart:convert';
import 'dart:developer';

import 'package:client/core/app_failure/app_failure.dart';
import 'package:client/core/constants/server_constant.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'follow_repository.g.dart';

@riverpod
FollowRepository followRepository(FollowRepositoryRef ref) {
  return FollowRepository();
}

class FollowRepository {
  Future<Either<AppFailure, String>> followUser(
      {required String targetUserId, required String token}) async {
    final url = Uri.parse('${ServerConstant.serverURL}/follow/$targetUserId');

    final request = http.MultipartRequest('POST', url);

    request.fields['target_user_id'] = targetUserId;

    request.headers['x-auth-token'] = token;

    final res = await request.send();
    log(res.toString(), name: "Response in home repo");

    if (res.statusCode != 201) {
      return Left(AppFailure(await res.stream.bytesToString()));
    }
    return Right(await res.stream.bytesToString());
  }

  Future<void> unFollowUser(
      {required String targetUserId, required String token}) async {
    final url =
        Uri.parse('${ServerConstant.serverURL}/follow/unfollow/$targetUserId');

    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      log('UnFollowed successfully');
    } else {
      log('Error: ${response.body}');
    }
  }

  Future<Either<AppFailure, Map<String, int>>> getFollowCounts({
    required String token,
    required String userId,
  }) async {
    try {
      final res = await http.get(
        Uri.parse(
            '${ServerConstant.serverURL}/follow/user/follow_counts/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      final Map<String, dynamic> resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail'] ?? "Unknown error"));
      }

      return Right({
        "followers": resBodyMap['follower_count'] ?? 0,
        "following": resBodyMap['following_count'] ?? 0,
      });
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
