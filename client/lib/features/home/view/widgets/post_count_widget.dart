import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';

class PostCountWidget extends ConsumerWidget {
  const PostCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getPostsCountsProvider).when(
        data: (postCount) {
          return Column(
            children: [
              Text(
                "${postCount['post_counts'] ?? 0}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Text("Posts"),
            ],
          );
        },
        error: (error, _) => Center(
              child: CircularProgressIndicator(),
            ),
        loading: () => Loader());
  }
}
