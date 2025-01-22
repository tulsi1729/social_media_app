import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/home/models/post_model.dart';
import 'package:client/features/home/view/screens/create_post_screen.dart';
import 'package:client/features/home/view/widgets/heart_animation_widget.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final bool isEditMode;
  final PostModel? preFilledPost;
  const ProfileScreen({super.key, this.isEditMode = false, this.preFilledPost});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final captionController = TextEditingController();
  bool isHeartAnimation = false;
  bool isLiked = false;
  late Future<List<PostModel>> futurePosts;

  void navigateToCreatePost(BuildContext context, PostModel postModel) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CreatePostScreen(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      captionController.text = widget.preFilledPost!.caption;
    }
  }

  Future<void> signOut() async {}

  @override
  Widget build(BuildContext context) {
    final icon = isLiked ? Icons.favorite : Icons.favorite_border_outlined;
    final color = isLiked ? Colors.red : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Posts"),
        elevation: 4,
        actions: [
          TextButton(onPressed: signOut, child: const Text("Sign out"))
        ],
      ),
      body: ref.watch(getMyPostsProvider).when(
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
                                      await ref
                                          .read(homeViewModelProvider.notifier)
                                          .likePost(
                                            postId: post.id,
                                          );
                                      // isLiked == true
                                      //     ? Icon(Icons.favorite)
                                      //     : Icon(Icons.abc);
                                      setState(
                                        () {
                                          isHeartAnimation = true;
                                          isLiked = true;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Opacity(
                                  opacity: isHeartAnimation ? 1 : 0,
                                  child: HeartAnimationWidget(
                                    isAnimating: isHeartAnimation,
                                    duration: const Duration(milliseconds: 700),
                                    child: const Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 150,
                                    ),
                                    onEnd: () => setState(
                                        () => isHeartAnimation = false),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Column(
                                  children: [
                                    HeartAnimationWidget(
                                      isAnimating: isLiked,
                                      child: IconButton(
                                          icon: Icon(
                                            icon,
                                            color: color,
                                            size: 28,
                                          ),
                                          onPressed: () async {
                                            if (post.id == post.id)
                                              setState(() {
                                                isLiked = !isLiked;
                                              });

                                            await ref
                                                .read(homeViewModelProvider
                                                    .notifier)
                                                .likePost(
                                                  postId: post.id,
                                                );
                                            // isLiked == true
                                            //     ? Icon(Icons.favorite)
                                            //     : Icon(Icons.abc);
                                          }),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                        icon: const Icon(Icons.comment),
                                        onPressed: () async {
                                          await ref
                                              .read(homeViewModelProvider
                                                  .notifier)
                                              .commentPost(
                                                postId: post.id,
                                                comment: "comment",
                                                time: DateTime.now(),
                                              );
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (context) => buildSheet(),
                                          );
                                        }),
                                  ],
                                ),
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
                                          token: ref
                                              .read(
                                                  currentUserNotifierProvider)!
                                              .token,
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
          ),
    );
  }

  Widget buildSheet() => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: const [
              Text(
                " Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n'a pas fait que survivre cinq siècles, mais s'est aussi adapté à la bureautique informatique, sans que son contenu n'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                " Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n'a pas fait que survivre cinq siècles, mais s'est aussi adapté à la bureautique informatique, sans que son contenu n'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                " Lorem Ipsum est simplement du faux texte employé dans la composition et la mise en page avant impression. Le Lorem Ipsum est le faux texte standard de l'imprimerie depuis les années 1500, quand un imprimeur anonyme assembla ensemble des morceaux de texte pour réaliser un livre spécimen de polices de texte. Il n'a pas fait que survivre cinq siècles, mais s'est aussi adapté à la bureautique informatique, sans que son contenu n'en soit modifié. Il a été popularisé dans les années 1960 grâce à la vente de feuilles Letraset contenant des passages du Lorem Ipsum, et, plus récemment, par son inclusion dans des applications de mise en page de texte, comme Aldus PageMaker.",
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      );
}
