import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/home/view/screens/my_posts_screen.dart';
import 'package:client/features/home/view/widgets/profile_widget.dart';
import 'package:client/features/profile/view/widgets/follow_count_widget.dart';
import 'package:client/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hey hello"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      body: ref.watch(getFollowCountProvider).when(
            data: (follows) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    flex: 2,
                    child: ProfileWidget(),
                  ),

                  //my posts
                  Flexible(
                    flex: 3,
                    child: MyPostsScreen(),
                  ),
                ],
              );
            },
            error: (error, _) => Center(child: Text(error.toString())),
            loading: () => const Loader(),
          ),
    );
  }
}
