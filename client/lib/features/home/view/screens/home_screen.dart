import 'package:client/features/home/view/screens/post_screen.dart';
import 'package:client/features/story/view/screens/story_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Social Media App"),
          ],
        ),
        elevation: 2,
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: StoryScreen(),
          ),
          Flexible(
            flex: 3,
            child: PostScreen(),
          ),
        ],
      ),
    );
  }
}
