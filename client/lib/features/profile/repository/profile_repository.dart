import 'dart:convert';

import 'package:client/core/app_failure/app_failure.dart';
import 'package:client/core/constants/server_constant.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_repository.g.dart';

@riverpod
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository();
}

class ProfileRepository {
  Future<Either<AppFailure, Map<String, int>>> getPostsCounts({
    required String token,
    required String userId,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/post/post_counts/$userId'),
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
        "post_counts": resBodyMap['post_counts'] ?? 0,
      });
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
