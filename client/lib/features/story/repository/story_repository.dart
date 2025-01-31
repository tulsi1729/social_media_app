import 'dart:convert';
import 'dart:developer';
import 'package:client/core/app_failure/app_failure.dart';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/features/home/models/story_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'story_repository.g.dart';

@riverpod
StoryRepository storyRepository(StoryRepositoryRef ref) {
  return StoryRepository();
}

class StoryRepository {
  Future<Either<AppFailure, String>> createStory({
    required String selectedImage,
    required String views,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.serverURL}/story/create_story'),
      );

      log(selectedImage.toString(), name: "repo selected story image");
      request.fields['image_url'] = selectedImage;
      request.fields['views'] = views;

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

  Future<Either<AppFailure, List<StoryModel>>> getStories({
    required String token,
  }) async {
    try {
      final res = await http.get(
          Uri.parse(
            '${ServerConstant.serverURL}/story/get_stories',
          ),
          headers: {
            'Content-Type': 'application/json',
            'x-auth-token': token,
          });
      log(res.body.toString(), name: "repo home story");

      if (res.statusCode != 200) {
        final Map<String, dynamic> errorBody = jsonDecode(res.body);
        return Left(AppFailure(errorBody['detail'] ?? 'Unknown error'));
      }

      final List<dynamic> responseBody = jsonDecode(res.body);
      // final Map<String, dynamic> responseBody = jsonDecode(res.body);

      // // Ensure you're accessing the "stories" key from the response
      // final List<dynamic> storiesList = responseBody['stories'];

      final stories = responseBody
          .map((storyData) => StoryModel.fromMap(storyData))
          .toList();

      log(stories.toString(), name: "repo Right story");

      return Right(stories);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
