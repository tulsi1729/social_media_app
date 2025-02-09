import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/follow/viewmodel/follow_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowCountWidget extends ConsumerWidget {
  const FollowCountWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getFollowCountProvider).when(
          data: (follows) {
            return Row(
              children: [
                // Followers, Followings

                Column(
                  children: [
                    Text(
                      "${follows['followers'] ?? 0}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Text("Followers"),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: [
                    Text(
                      "${follows['following'] ?? 0}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    Text("Following"),
                  ],
                ),
              ],
            );
          },
          error: (error, _) => Center(child: Text(error.toString())),
          loading: () => const Loader(),
        );
  }
}
