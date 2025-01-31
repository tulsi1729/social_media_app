import 'package:client/features/story/view/screens/story.dart';
import 'package:client/features/story/view/widgets/story_circles.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/story/view/widgets/story_page.dart';
import 'package:flutter/material.dart';

class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({super.key});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  void _openStory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StoryPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 13,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // return Story();
          return StoryCircles(
              // function: _openStory,
              );
        },
      ),
    );
  }
}
