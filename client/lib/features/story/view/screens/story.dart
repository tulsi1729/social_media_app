import 'package:client/core/utils.dart';
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
              return stories.isEmpty
                  ? Center(child: Text("No Story Found"))
                  : Card(
                      child: Expanded(
                        child: ListView.builder(
                            itemCount: stories.length,
                            itemBuilder: (context, index) {
                              final story = stories[index];
                              formatDateTimeString(story.createdAt);

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
