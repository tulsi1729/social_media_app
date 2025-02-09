import 'dart:convert';
import 'dart:developer';

import 'package:client/core/app_failure/app_failure.dart';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/features/home/models/post_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_repository.g.dart';

@riverpod
HomeRepository homeRepository(HomeRepositoryRef ref) {
  return HomeRepository();
}

class HomeRepository {
  Future<Either<AppFailure, String>> createPost({
    required String caption,
    required String selectedImage,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.serverURL}/post/create_post'),
      );

      log(selectedImage.toString(), name: "repo selected image");
      request.fields['image_url'] = selectedImage;

      request.fields['caption'] = caption;
      request.headers['x-auth-token'] = token;

      final res = await request.send();
      log(res.toString(), name: "Response in home repo");

      if (res.statusCode != 201) {
        return Left(AppFailure(await res.stream.bytesToString()));
      }
      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(
        AppFailure(
          e.toString(),
        ),
      );
    }
  }

  Future<Either<AppFailure, List<PostModel>>> geMyPosts({
    required String token,
  }) async {
    try {
      final res = await http.get(
          Uri.parse(
            '${ServerConstant.serverURL}/post/my_posts',
          ),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          });
      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;

      List<PostModel> posts = [];

      for (final map in resBodyMap) {
        posts.add(PostModel.fromMap(map));
      }
      return Right(posts);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, List<PostModel>>> getPosts({
    required String token,
  }) async {
    try {
      final res = await http.get(
          Uri.parse('${ServerConstant.serverURL}/post/get_posts'),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          });
      var resBodyMap = jsonDecode(res.body);

      if (res.statusCode != 200) {
        resBodyMap = resBodyMap as Map<String, dynamic>;
        return Left(AppFailure(resBodyMap['detail']));
      }
      resBodyMap = resBodyMap as List;

      List<PostModel> posts = [];

      for (final map in resBodyMap) {
        posts.add(PostModel.fromMap(map));
      }
      return Right(posts);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<void> deletePost({
    required String postId,
    required String token,
  }) async {
    final url =
        Uri.parse('${ServerConstant.serverURL}/post/delete_post/$postId');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        print("Post deleted successfully");
      } else {
        print("Failed to delete post: ${response.body}");
      }
    } catch (e) {
      print("Error deleting post: $e");
    }
  }

  Future<void> editPost({
    required String postId,
    required String caption,
    required String selectedImage,
    required String token,
  }) async {
    final url = Uri.parse('${ServerConstant.serverURL}/post/edit_post/$postId');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'x-auth-token': token,
        },
        body: {
          "caption": caption,
          "image_url": selectedImage,
        },
      );
      log(response.body, name: "res in repo edit");

      if (response.statusCode == 200) {
        log("Post updated successfully: ${response.body}");
      } else {
        log("Failed to update post: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      log("Error updating post: $e");
    }
  }

  Future<Either<AppFailure, String>> likePost({
    required String postId,
    required String likedBy,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.serverURL}/like/create_like'),
      );

      request.fields['post_id'] = postId;

      request.fields['liked_by'] = likedBy;
      request.headers['x-auth-token'] = token;

      final res = await request.send();
      log(res.toString(), name: "Response in home repo");

      if (res.statusCode != 201) {
        return Left(AppFailure(await res.stream.bytesToString()));
      }
      return Right(await res.stream.bytesToString());
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
