import 'package:client/features/story/view/widgets/all_stories.dart';
import 'package:client/features/story/view/widgets/my_stories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({super.key});

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {

  @override
  Widget build(BuildContext context) {
            return SingleChildScrollView(
              child: Row(
                children: [
                    MyStories(),
                    SizedBox(width: 10,),
                    AllStories(),
                ],
              ),
            );
           }
}

