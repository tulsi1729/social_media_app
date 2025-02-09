import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/home/models/post_model.dart';
import 'package:client/features/home/view/add_screen/create_post_screen.dart';
import 'package:client/features/home/view/widgets/comment_tile.dart';
import 'package:client/features/home/view/widgets/like_button.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPostsScreen extends ConsumerStatefulWidget {
  final bool isEditMode;
  final PostModel? preFilledPost;
  const MyPostsScreen({super.key, this.isEditMode = false, this.preFilledPost});

  @override
  ConsumerState<MyPostsScreen> createState() => _MyPostsScreenState();
}

class _MyPostsScreenState extends ConsumerState<MyPostsScreen> {
  bool isHeartAnimation = false;
  bool like = false;
  late Future<List<PostModel>> futurePosts;

  void navigateToCreatePost(BuildContext context, PostModel postModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreatePostScreen(
          isEditMode: true,
          preFilledPost: postModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getMyPostsProvider).when(
          data: (posts) {
            return Card(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  List<String> imageUrlList = post.imageUrl.split(",");

                  return Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.red)),
                    child: ListTile(
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 20.0,
                              ),
                              Text("Name"),
                            ],
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: GestureDetector(
                                  child: Row(
                                    children: imageUrlList.map((imageUrl) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.network(
                                          imageUrl,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                  onDoubleTap: () async {
                                    // await ref
                                    //     .read(homeViewModelProvider.notifier)
                                    //     .likePost(
                                    //       postId: post.id,
                                    //     );

                                    // setState(
                                    //   () {
                                    //     isHeartAnimation = true;
                                    //     isLiked = true;
                                    //   },
                                    // );
                                  },
                                ),
                              ),
                              // Opacity(
                              //   opacity: isHeartAnimation ? 1 : 0,
                              //   child: HeartAnimationWidget(
                              //     isAnimating: isHeartAnimation,
                              //     duration: const Duration(milliseconds: 700),
                              //     child: const Icon(
                              //       Icons.favorite,
                              //       color: Colors.white,
                              //       size: 150,
                              //     ),
                              //     onEnd: () => setState(
                              //         () => isHeartAnimation = false),
                              //   ),
                              // ),
                            ],
                          ),
                          Row(
                            children: [
                              LikeButton(postId: post.id),
                              CommentTile(postId: post.id),
                              Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.share),
                                    onPressed: () {},
                                  ),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Caption : ${post.caption}'),
                              SizedBox(
                                width: 50,
                              ),
                              IconButton(
                                onPressed: () {
                                  navigateToCreatePost(
                                    context,
                                    post,
                                  );
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await ref
                                      .read(homeViewModelProvider.notifier)
                                      .deletedPost(
                                        postId: post.id,
                                      );
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
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
        );
  }
}
