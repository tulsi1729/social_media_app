import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/home/models/story_model.dart';
import 'package:client/features/story/view/widgets/my_profile.dart';
import 'package:client/features/story/view/screens/story_page.dart';
import 'package:client/features/story/viewmodel/story_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyStories extends ConsumerStatefulWidget {
  const MyStories({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyStoriesState();
}

class _MyStoriesState extends ConsumerState<MyStories> {

  void _openStory( List<StoryModel> stories) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryPage(
          stories: stories,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getMyStoriesProvider).when(
        data: (myStories) {
          return GestureDetector(
            onTap: () => _openStory(myStories),
            child: MyProfile(),
          );
        },
        error: (error, str) {
            return Center(
              child: Text(error.toString()),
            );
          },
          loading: () => Loader());
  }
}
