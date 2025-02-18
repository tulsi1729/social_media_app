import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/home/models/story_model.dart';
import 'package:client/features/story/view/widgets/story_page.dart';
import 'package:client/features/story/viewmodel/story_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({super.key});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  // int currentStoryIndex = 0;
  // final List<StoryModel> stories;

  void _openStory(int index, List<StoryModel> stories) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryPage(
          initialIndex: index,
          stories: stories,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ref.watch(getStoriesProvider).when(
          data: (stories) {
            return Row(
              children: [
                CircleAvatar(
                  radius: 50,
                ),
                ...(stories.asMap().entries.map((entry) {
                  int index = entry.key;
                  StoryModel storyModel = entry.value;
                  return GestureDetector(
                    onTap: () =>
                        _openStory(index, stories), // Pass index correctly
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(storyModel.imageUrl),
                    ),
                  );
                }).toList()),
              ],
            );
          },
          error: (error, str) {
            return Center(
              child: Text(error.toString()),
            );
          },
          loading: () => Loader()),
    );
  }
}
