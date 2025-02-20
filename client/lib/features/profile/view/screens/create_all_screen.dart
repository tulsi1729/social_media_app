import 'package:client/features/home/view/add_screen/create_post_screen.dart';
import 'package:client/features/reel/view/screens/create_reel_screen.dart';
import 'package:client/features/story/view/screens/create_story_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAllScreen extends ConsumerWidget {
  const CreateAllScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreatePostScreen(),
            ),
          ),
          child: Text("Create Post"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateStoryScreen(),
            ),
          ),
          child: Text("Create Story"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => CreateReelScreen(),
            ),
          ),
          child: Text("Create Reel"),
        ),
        
      ],
    );
  }
}
