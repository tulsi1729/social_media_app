import 'package:flutter/material.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  bool isHeartAnimation = false;
  bool isLiked = false;

  // Future<void> signOut() async {
  //   await supabase.auth.signOut();
  // }

  @override
  Widget build(BuildContext context) {
    // final postsStream = supabase
    //     .from(SupabaseTableNames.postTable)
    //     .stream(primaryKey: [SupabaseFieldNames.id]);

    // final icon = isLiked ? Icons.favorite : Icons.favorite_border_outlined;
    // final color = isLiked ? Colors.red : Colors.grey;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
        elevation: 4,
        actions: [
          TextButton(
              onPressed: () {
                //signuot
              },
              child: const Text("Sign out"))
        ],
      ),
      body: Text("Posts"),
      // StreamBuilder(
      //   stream: postsStream,
      //   builder: (context, snapshot) {
      //     if (!snapshot.hasData) {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //     final posts = snapshot.data!;
      //     return Card(
      //       child: ListView.builder(
      //         // itemCount: posts.length,
      //         itemBuilder: (context, index) {
      //           final post = posts[index];
      //           return ListTile(
      //             leading: const Column(
      //               children: [
      //                 CircleAvatar(
      //                   radius: 20.0,
      //                   backgroundImage: NetworkImage('assets/animal.jpg'),
      //                   // backgroundColor: Color.fromARGB(0, 91, 15, 15),
      //                 ),
      //                 Text("Name"),
      //               ],
      //             ),
      //             title: Column(
      //               children: [
      //                 // if (post[SupabaseFieldNames.mediaUrl] != null)
      //                 //   GestureDetector(
      //                 //     child: Stack(
      //                 //       alignment: Alignment.center,
      //                 //       children: [
      //                 //         Image.network(
      //                 //           post[SupabaseFieldNames.mediaUrl],
      //                 //           height: 200,
      //                 //           width: 500,
      //                 //           fit: BoxFit.cover,
      //                 //         ),
      //                 //         Opacity(
      //                 //           opacity: isHeartAnimation ? 1 : 0,
      //                 //           child: HeartAnimationWidget(
      //                 //             isAnimating: isHeartAnimation,
      //                 //             duration: const Duration(milliseconds: 700),
      //                 //             child: const Icon(
      //                 //               Icons.favorite,
      //                 //               color: Colors.white,
      //                 //               size: 150,
      //                 //             ),
      //                 //             onEnd: () =>
      //                 //                 setState(() => isHeartAnimation = false),
      //                 //           ),
      //                 //         ),
      //                 //       ],
      //                 //     ),
      //                 //     onDoubleTap: () {
      //                 //       setState(
      //                 //         () {
      //                 //           isHeartAnimation = true;
      //                 //           isLiked = true;
      //                 //         },
      //                 //       );
      //                 //     },
      //                 //   ),
      //                 // if (post[SupabaseFieldNames.mediaUrl] != null)
      //                 GestureDetector(
      //                   child: Stack(
      //                     alignment: Alignment.center,
      //                     children: [
      //                       Image.asset(
      //                         'assets/animal.jpg',
      //                         height: 200,
      //                         width: 500,
      //                         fit: BoxFit.cover,
      //                       ),
      //                       Opacity(
      //                         opacity: isHeartAnimation ? 1 : 0,
      //                         // child: HeartAnimationWidget(
      //                         //   isAnimating: isHeartAnimation,
      //                         //   duration: const Duration(milliseconds: 700),
      //                         //   child: const Icon(
      //                         //     Icons.favorite,
      //                         //     color: Colors.white,
      //                         //     size: 150,
      //                         //   ),
      //                         //   onEnd: () =>
      //                         //       setState(() => isHeartAnimation = false),
      //                         // ),
      //                       ),
      //                     ],
      //                   ),
      //                   onDoubleTap: () {
      //                     setState(
      //                       () {
      //                         isHeartAnimation = true;
      //                         isLiked = true;
      //                       },
      //                     );
      //                   },
      //                 ),
      //                 Row(
      //                   children: [
      //                     Column(
      //                       children: [
      //                         // HeartAnimationWidget(
      //                         //   isAnimating: isLiked,
      //                         //   child: IconButton(
      //                         //     icon: Icon(
      //                         //       icon,
      //                         //       color: color,
      //                         //       size: 28,
      //                         //     ),
      //                         //     onPressed: () =>
      //                         //         setState(() => isLiked = !isLiked),
      //                         //   ),
      //                         // ),
      //                       ],
      //                     ),
      //                     Column(
      //                       children: [
      //                         IconButton(
      //                           icon: const Icon(Icons.comment),
      //                           onPressed: () => showModalBottomSheet(
      //                             isScrollControlled: true,
      //                             context: context,
      //                             builder: (context) => buildSheet(),
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                     Column(
      //                       children: [
      //                         IconButton(
      //                           icon: const Icon(Icons.share),
      //                           onPressed: () {},
      //                         ),
      //                       ],
      //                     )
      //                   ],
      //                 ),
      //                 const SizedBox(
      //                   height: 10,
      //                 ),
      //                 // Text('Caption : ${post[SupabaseFieldNames.caption]}'),
      //               ],
      //             ),
      //           );
      //         },
      //       ),
      //     );
      //   },
      // ),
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
