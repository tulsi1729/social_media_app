import 'package:client/features/home/models/post_model.dart';
import 'package:client/features/home/view/add_screen/create_post_screen.dart';
import 'package:client/features/home/view/widgets/comment_tile.dart';
import 'package:client/features/home/view/widgets/like_button.dart';
import 'package:client/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';

class PostScreen extends ConsumerStatefulWidget {
  final bool isEditMode;
  final PostModel? preFilledPost;
  const PostScreen({super.key, this.isEditMode = false, this.preFilledPost});

  @override
  ConsumerState<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState<PostScreen> {
  final captionController = TextEditingController();
  bool isLiked = false;

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

  @override
  Widget build(BuildContext context) {
    return ref.watch(getPostsProvider).when(
          data: (posts) {
            return Card(
              child: ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  List<String> imageUrlList = post.imageUrl.split(",");
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //profile
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ref.watch(getAllUserProvider).when(
                                        data: (profile) {
                                          return CircleAvatar(
                                            radius: 30,
                                            backgroundImage: (profile.first
                                                            .profileImage !=
                                                        null &&
                                                    profile.first.profileImage!
                                                        .isNotEmpty
                                                ? NetworkImage(
                                                    profile.first.profileImage!)
                                                : const AssetImage(
                                                        'assets/default_profile.png')
                                                    as ImageProvider),
                                          );
                                        },
                                        error: (error, str) => Center(
                                          child: Text(error.toString()),
                                        ),
                                        loading: () => Loader(),
                                      ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  ref.watch(getAllUserProvider).when(
                                        data: (profile) {
                                          return Text(
                                            profile.isNotEmpty
                                                ? profile.first.userName ??
                                                    'Profile'
                                                : 'Profile',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 25),
                                          );
                                        },
                                        error: (error, _) => Center(
                                          child: Text(error.toString()),
                                        ),
                                        loading: () => Loader(),
                                      ),
                                ],
                              ),
                              // IconButton(
                              //   onPressed: () {},
                              //   icon: Icon(Icons.menu),
                              // ),
                            ],
                          ),
                        ),

                        //post
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis
                                  .horizontal, // Allow horizontal scrolling
                              child: Row(
                                children: imageUrlList.map((imageUrl) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      imageUrl, // Trim spaces to avoid errors
                                      width:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),

                        //below the post like,comment,share button
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    LikeButton(postId: post.id)
                                  ],
                                ),
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
                            // IconButton(
                            //   icon: const Icon(Icons.bookmark),
                            //   onPressed: () {},
                            // )
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
                          ],
                        ),
                        //likedBy line
                         isLiked == true ?
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "Liked by ",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ref.watch(getMyUserProvider).when(
                                  data: (user) => Text(user.first.userName ?? ''),
                                  error: (error, str) {
                                    return Center(
                                      child: Text(str.toString()),
                                    );},
                                    loading:
                                    () => Loader(),
                                  ),
                            ],
                          ),
                        )
                        :
                                  Text(""),
                        
                      ],
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
