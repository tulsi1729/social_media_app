import 'dart:convert';
import 'dart:developer';

import 'package:client/core/app_failure/app_failure.dart';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/features/comment/model/comment_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;

part 'comment_repository.g.dart';

@riverpod
CommentRepository commentRepository(CommentRepositoryRef ref) {
  return CommentRepository();
}

class CommentRepository {
  Future<Either<AppFailure, String>> commentPost({
    required String comment,
    required String postId,
    required String createdBy,
    required DateTime createdOn,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.serverURL}/comment/create_comment'),
      );

      request.fields['comment'] = comment;
      request.fields['post_id'] = postId;
      request.fields['created_by'] = createdBy;
      request.fields['created_on'] = createdOn.toString();
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

  Future<Either<AppFailure, List<CommentModel>>> getComments({
    required String token,
    required String postId,
  }) async {
    try {
      final res = await http.get(
          Uri.parse(
            '${ServerConstant.serverURL}/comment/get_comments/$postId',
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

      List<CommentModel> comments = [];

      for (final map in resBodyMap) {
        comments.add(CommentModel.fromMap(map));
      }
      return Right(comments);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<void> deleteComment({
    required int commentId,
    required String token,
  }) async {
    final url = Uri.parse(
        '${ServerConstant.serverURL}/comment/delete_comment/$commentId');

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
}
