import 'package:client/core/utils.dart';
import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/comment/viewmodel/comment_viewmodel.dart';
import 'package:client/features/home/view/screens/profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class CommentTile extends ConsumerStatefulWidget {
  final String postId;
  const CommentTile({super.key, required this.postId});

  @override
  ConsumerState<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends ConsumerState<CommentTile> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final commentsAsyncValue = ref.watch(commentsProvider(widget.postId));
    return Column(
      children: [
        IconButton(
          icon: const Icon(Icons.comment),
          onPressed: () async {
            showModalBottomSheet(
              context: context,
              builder: (context) => DraggableScrollableSheet(
                initialChildSize: 0.4,
                maxChildSize: 0.8,
                minChildSize: 0.4,
                expand: false,
                builder: (_, controller) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Comments",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Flexible(
                          flex: 5,
                          child: Row(
                            children: [
                              Flexible(
                                flex: 4,
                                child: TextField(
                                  controller: commentController,
                                  decoration: const InputDecoration(
                                    hintText: 'comment',
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: IconButton(
                                  onPressed: () async {
                                    await ref
                                        .read(commentViewModelProvider.notifier)
                                        .commentPost(
                                          comment: commentController.text,
                                          postId: widget.postId,
                                          createdOn: DateTime.now(),
                                        );
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.arrow_upward),
                                ),
                              ),
                            ],
                          ),
                        ),
                        commentsAsyncValue.when(
                          data: (comments) {
                            return Expanded(
                              child: ListView.builder(
                                controller: controller,
                                itemCount: comments.length,
                                itemBuilder: (context, index) {
                                  final comment = comments[index];

                                  formatDateTimeString(comment.createdOn);
                                  return Card(
                                      child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 20,
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                'created By :  ${comment.createdBy}'),
                                            Text(
                                                'comment : ${comment.comment}'),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                ref
                                                    .read(
                                                        commentViewModelProvider
                                                            .notifier)
                                                    .deleteComment(
                                                        commentId: comment.id);
                                              },
                                              icon: Icon(Icons.remove),
                                            ),
                                            Text(
                                              formatDateTimeString(
                                                  comment.createdOn),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ));
                                },
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
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
        ref.watch(commentCountProvider(widget.postId)).when(
            data: (commentCount) {
              return Text(commentCount.toString());
            },
            error: (error, str) => Center(
                  child: Text(error.toString()),
                ),
            loading: () => Loader()),
      ],
    );
  }
}
