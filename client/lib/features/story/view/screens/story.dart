import 'dart:developer';

import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/story/viewmodel/story_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Story extends ConsumerWidget {
  const Story({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Story"),
      ),
      body: ref.watch(getStoriesProvider).when(
            data: (stories) {
              return Card(
                child: Expanded(
                  child: ListView.builder(
                      itemCount: stories.length,
                      itemBuilder: (context, index) {
                        final story = stories[index];
                        String formatDateTimeString(DateTime date) {
                          DateTime now = DateTime.now();
                          Duration difference = now.difference(date);
                          log("Time ago: $difference");

                          if (difference.inSeconds < 60) {
                            return '${difference.inSeconds} seconds ago';
                          } else if (difference.inMinutes < 60) {
                            return '${difference.inMinutes} minutes ago';
                          } else if (difference.inHours < 24) {
                            return '${difference.inHours} hours ago';
                          } else if (difference.inDays < 30) {
                            return '${difference.inDays} days ago';
                          } else if (difference.inDays < 365) {
                            return '${(difference.inDays / 30).floor()} months ago';
                          } else {
                            return '${(difference.inDays / 365).floor()} years ago';
                          }
                        }

                        return ListTile(
                          title: Column(
                            children: [
                              Image.network(story.imageUrl),
                              Text(formatDateTimeString(story.createdAt)),
                              Text(story.views.toString()),
                            ],
                          ),
                        );
                      }),
                ),
              );
            },
            error: (error, st) {
              return Center(
                child: Text(
                  error.toString(),
                ),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}
