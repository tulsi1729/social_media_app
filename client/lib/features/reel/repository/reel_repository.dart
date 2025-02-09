import 'dart:convert';
import 'dart:developer';

import 'package:client/core/app_failure/app_failure.dart';
import 'package:client/core/constants/server_constant.dart';
import 'package:client/features/reel/model/reel_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reel_repository.g.dart';

@riverpod
ReelRepository reelRepository(ReelRepositoryRef ref) {
  return ReelRepository();
}

class ReelRepository {
  Future<Either<AppFailure, String>> createReel({
    required String caption,
    required String selectedVideo,
    required String token,
  }) async {
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${ServerConstant.serverURL}/reel/create_reel'),
      );

      log(selectedVideo.toString(), name: "repo selected video");
      request.fields['video_url'] = selectedVideo;

      request.fields['caption'] = caption;
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

  Future<Either<AppFailure, List<ReelModel>>> getReels({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse('${ServerConstant.serverURL}/reel/get_reels'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      log(res.body.toString(), name: "repo home story");

      if (res.statusCode != 200) {
        final Map<String, dynamic> errorBody = jsonDecode(res.body);
        return Left(AppFailure(errorBody['detail'] ?? 'Unknown error'));
      }

      final Map<String, dynamic> responseBody = jsonDecode(res.body);

      final List<dynamic> reelsList = responseBody['reels'];
      final reels = reelsList.map((data) => ReelModel.fromMap(data)).toList();

      log(reels.toString(), name: "repo Right story");

      return Right(reels);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
