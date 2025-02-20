import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/home/models/story_model.dart';
import 'package:client/features/story/view/widgets/all_user_profile.dart';
import 'package:client/features/story/view/screens/story_page.dart';
import 'package:client/features/story/viewmodel/story_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllStories extends ConsumerStatefulWidget {
  const AllStories({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AllStoriesState();
}

class _AllStoriesState extends ConsumerState<AllStories> {

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
    return ref.watch(getStoriesProvider).when(
        data: (allStories) {
          return GestureDetector(
            onTap: () => _openStory(allStories),
            child: AllUserProfile(),
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
