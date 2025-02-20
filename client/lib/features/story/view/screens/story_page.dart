import 'dart:async';

import 'package:client/features/home/models/story_model.dart';
import 'package:client/features/story/view/widgets/story_bars.dart';
import 'package:flutter/material.dart';

class StoryPage extends StatefulWidget {
  // final int initialIndex;
  final List<StoryModel> stories;
  const StoryPage(
      {super.key, required this.stories});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  int currentStoryIndex = 0;
  late List<double> percentWatched;
  Timer? _timer;

  void initState() {
    super.initState();
    // currentStoryIndex = widget.initialIndex;
    percentWatched = List.generate(widget.stories.length, (_) => 0);
    _startWatching();
  }

  void _startWatching() {
    _timer?.cancel();


    _timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
      setState(() {
        // only add 0.01 as long as it's below 1
        if (percentWatched[currentStoryIndex] + 0.01 < 1) {
          percentWatched[currentStoryIndex] += 0.01;
        }
        // if 0.01 below exceeds 1,set percentage to 1 and cancel timer
        else {
          percentWatched[currentStoryIndex] = 1;
          timer.cancel();
          _nextStory();
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

    //user taps on first half of the screen
    if (dx < screenWidth / 2) {
      setState(() {
        //as long as this isn't the first story
        if (currentStoryIndex > 0) {
          // set previous and current story watched percentage back to 0 
          percentWatched[currentStoryIndex - 1] = 0;
          percentWatched[currentStoryIndex] = 0;

          //go to previous story
          currentStoryIndex--;
        }
      });
    }
     //user taps on first half of the screen
    else {
      setState(() {
      //if there are more story left
        if(currentStoryIndex <  widget.stories.length - 1){
          //finish current story
        percentWatched[currentStoryIndex] = 1;
        //move to next story
        currentStoryIndex++;

      }
      //if user is on the last story,finish this
      else{
        percentWatched[currentStoryIndex] = 1;
      }}
      );
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
