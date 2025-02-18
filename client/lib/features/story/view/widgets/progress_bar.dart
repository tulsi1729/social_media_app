import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressBar extends StatelessWidget {
  final double percentWatched;

  const ProgressBar({super.key, required this.percentWatched});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      lineHeight: 4,
      percent: percentWatched.clamp(
          0.0, 1.0), // Ensure percentage is between 0 and 1
      progressColor: Colors.white,
      backgroundColor: Colors.grey.withOpacity(0.3),
    );
  }
}
