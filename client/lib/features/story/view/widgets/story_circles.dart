import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoryCircles extends ConsumerStatefulWidget {
  final function;

  const StoryCircles({this.function});

  @override
  ConsumerState<StoryCircles> createState() => _StoryCirclesState();
}

class _StoryCirclesState extends ConsumerState<StoryCircles> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 50,
                  // backgroundColor: const Color.fromARGB(255, 248, 147, 213),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    padding: EdgeInsets.all(6),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            "name",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
