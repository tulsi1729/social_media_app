import 'dart:async';

import 'package:client/features/home/models/story_model.dart';
import 'package:client/features/story/view/widgets/story_bars.dart';
import 'package:flutter/material.dart';

class StoryPage extends StatefulWidget {
  final int initialIndex;
  final List<StoryModel> stories;
  const StoryPage(
      {super.key, required this.initialIndex, required this.stories});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  int currentStoryIndex = 0;
  late List<double> percentWatched;
  Timer? _timer;
  // final List<StoryModel> stories = [];
  // final List<Widget> myStories = [
  //   Story1(),
  //   Story2(),
  //   Story3(),
  //   Story1(),
  //   Story2(),
  // ];

  @override
  void initState() {
    super.initState();
    currentStoryIndex = widget.initialIndex;
    percentWatched = List.generate(widget.stories.length, (_) => 0);
    _startWatching();
  }

  void _startWatching() {
    _timer?.cancel();
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
        }
      });
    });
  }

  void _nextStory() {
    if (currentStoryIndex < widget.stories.length - 1) {
      setState(() {
        currentStoryIndex++;
        _startWatching();
      });
    } else {
      Navigator.pop(context); // Close the story viewer when done
    }
  }

  void _previousStory() {
    if (currentStoryIndex > 0) {
      setState(() {
        percentWatched[currentStoryIndex] = 0;
        currentStoryIndex--;
        _startWatching();
      });
    }
  }

  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      _previousStory();
    } else {
      _nextStory();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.deepPurple,
      body: GestureDetector(
        onTapDown: (details) => _onTapDown(details),
        child: Stack(
          children: [
            Center(
              child: Image.network(
                widget.stories[currentStoryIndex].imageUrl,
                fit: BoxFit.cover,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
              ),
            ),
            StoryBars(percentWatched: percentWatched),
          ],
        ),
      ),
    );
  }
}
