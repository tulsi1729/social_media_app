import 'dart:convert';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class LikeButton extends ConsumerStatefulWidget {
  final String postId;
  const LikeButton({super.key, required this.postId});
  @override
  ConsumerState<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends ConsumerState<LikeButton> {
  late Future<bool> _isLikedFuture;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isLikedFuture = isLiked(widget.postId);
  }

  Future<bool> isLiked(String postId) async {
    final token = ref.read(currentUserNotifierProvider)!.token;
    final res = await http.get(
      Uri.parse('${ServerConstant.serverURL}/like/is_liked/$postId'),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      },
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['is_liked'] ?? false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isLikedFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        _isLiked = snapshot.data ?? false;

        return Column(
          children: [
            IconButton(
              onPressed: () async {
                await ref
                    .read(homeViewModelProvider.notifier)
                    .likePost(postId: widget.postId);
                setState(() {
                  _isLiked = !_isLiked;
                  _isLikedFuture = isLiked(widget.postId);
                });
              },
              icon: Icon(
                Icons.favorite,
                color: _isLiked == true ? Colors.red : Colors.grey,
                size: _isLiked == true ? 32 : 28,
              ),
            ),
            ref.watch(likeCountProvider(widget.postId)).when(
                  data: (likes) {
                    return Text(likes.toString());
                  },
                  error: (error, st) {
                    return Center(
                      child: Text(
                        error.toString(),
                      ),
                    );
                  },
                  loading: () => const Loader(),
                )
          ],
        );
      },
    );
  }
}
