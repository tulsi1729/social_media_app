import 'dart:convert';
import 'dart:developer';

import 'package:client/core/app_failure/app_failure.dart';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/features/auth/model/user_model.dart';
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

  Future<void> editUser({
    required String uid,
    required String bio,
    required String userName,
    required String selectedProfileImage,
    required String token,
  }) async {
    final url = Uri.parse('${ServerConstant.serverURL}/auth/update_user');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'x-auth-token': token,
        },
        body: {
          'id': uid,
          'profile_image': selectedProfileImage,
          'bio': bio,
          'user_name': userName,
        },
      );
      log(response.body, name: "res in repo edit");

      if (response.statusCode == 200) {
        log("Profile updated successfully: ${response.body}");
      } else {
        log("Failed to update Profile: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      log("Error updating Profile: $e");
    }
  }

  Future<Either<AppFailure, List<UserModel>>> getUser({
    required String token,
  }) async {
    final url = Uri.parse("${ServerConstant.serverURL}/auth/user/get_user");

    try {
      final res = await http.get(
        url,
        headers: {
          "x-auth-token": token,
          "Content-Type": "application/json",
        },
      );

      if (res.statusCode != 200) {
        final Map<String, dynamic> errorBody = jsonDecode(res.body);
        return Left(AppFailure(errorBody['detail'] ?? 'Unknown error'));
      }

      final Map<String, dynamic> responseBody = jsonDecode(res.body);

      if (!responseBody.containsKey('user') || responseBody['user'] == null) {
        return Left(AppFailure("No users found"));
      }

      final dynamic usersData = responseBody['user'];

      if (usersData is! List) {
        return Left(AppFailure("Invalid response format: users is not a list"));
      }

      final List<UserModel> users =
          usersData.map((data) => UserModel.fromMap(data)).toList();

      return Right(users);
    } catch (e) {
      log("Error fetching profile: $e");
      return Left(AppFailure("Error fetching profile: $e"));
    }
  }
}
