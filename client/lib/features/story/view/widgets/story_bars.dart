import 'package:client/features/story/view/widgets/progress_bar.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StoryBars extends StatelessWidget {
  final List<double> percentWatched;
  StoryBars({super.key, required this.percentWatched});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
        child: Row(
          children: percentWatched
              .map((percent) =>
                  Expanded(child: ProgressBar(percentWatched: percent)))
              .toList(),
        ),
      ),
    );
  }
}
