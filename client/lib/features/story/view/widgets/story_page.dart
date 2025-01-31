import 'dart:async';

import 'package:client/features/home/models/story_model.dart';
import 'package:client/features/story/view/widgets/story_bars.dart';
import 'package:flutter/material.dart';

class StoryPage extends StatefulWidget {
  const StoryPage({super.key});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  int currentStoryIndex = 0;
  List<double> percentWatched = [];

  final List<StoryModel> myStories = [
    // Story1(),
    // Story2(),
    // Story3(),
  ];

  // final List<StoryModel> myStories = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < myStories.length; i++) {
      percentWatched.add(0);
    }
    _startWatching();
  }

  void _startWatching() {
    Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        // only add 0.01 as long as it's below 1
        if (percentWatched[currentStoryIndex] + 0.01 < 1) {
          percentWatched[currentStoryIndex] += 0.01;
        }
        // if 0.01 below exceeds 1,set percentage to 1 and cancel timer
        else {
          percentWatched[currentStoryIndex] = 1;
          timer.cancel();

          // also go to next story as long as there are more store to go through
          if (currentStoryIndex < myStories.length - 1) {
            currentStoryIndex++;
            // restart story timer
            _startWatching();
          }

          // id we are finishing last story then return to homepage
          else {
            Navigator.pop(context);
          }
        }
      });
    });
  }

  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    // user tap on first half of screen
    if (dx < screenWidth / 2) {
      setState(() {
        if (currentStoryIndex > 0) {
          percentWatched[currentStoryIndex - 1] = 0;
          percentWatched[currentStoryIndex] = 0;

          // go to previous screen
          currentStoryIndex--;
        }
      });
    }

    // user tap on second half of screen
    else {
      setState(() {
        // if there are more story left
        if (currentStoryIndex < myStories.length - 1) {
          //finish current story
          percentWatched[currentStoryIndex] = 1;
          // move to next story
          currentStoryIndex++;
        }
        // user is on the last story , finish the story
        percentWatched[currentStoryIndex] = 1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details),
        child: Stack(
          children: [
            // myStories[currentStoryIndex],

            StoryBars(percentWatched: percentWatched),
          ],
        ),
      ),
    );
  }
}
