// import 'package:client/features/auth/view/widgets/loader.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:client/features/comment/viewmodel/comment_viewmodel.dart';
// import 'package:flutter/material.dart';

// class CommentsList extends ConsumerStatefulWidget {
//   const CommentsList({
//     super.key,
//   });

//   @override
//   ConsumerState<CommentsList> createState() => _CommentsListState();
// }

// class _CommentsListState extends ConsumerState<CommentsList> {
//   final commentController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//         icon: const Icon(Icons.comment),
//         onPressed: () async {
//           showModalBottomSheet(
//             isScrollControlled: true,
//             context: context,
//             builder: (context) => DraggableScrollableSheet(
//               initialChildSize: 0.9,
//               // maxChildSize: 0.9,
//               minChildSize: 0.4,
//               builder: (_, controller) => Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       "Comments",
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(
//                       height: 20,
//                     ),
//                     Flexible(
//                       flex: 5,
//                       child: Row(
//                         children: [
//                           Flexible(
//                             flex: 4,
//                             child: TextField(
//                               controller: commentController,
//                               decoration: const InputDecoration(
//                                 hintText: 'comment',
//                                 border: OutlineInputBorder(),
//                               ),
//                             ),
//                           ),
//                           Flexible(
//                             flex: 1,
//                             child: IconButton(
//                               onPressed: () async {
//                                 await ref
//                                     .read(commentViewModelProvider.notifier)
//                                     .commentPost(
//                                       comment: commentController.text,
//                                       time: DateTime.now(),
//                                     );
//                               },
//                               icon: Icon(Icons.arrow_upward),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     ref.watch(getCommentsProvider).when(
//                           data: (comments) {
//                             return ListView.builder(
//                               itemBuilder: (context, index) {
//                                 final comment = comments[index];
//                                 return Card(
//                                     child: ListTile(
//                                   title: Text(comment.comment),
//                                 ));
//                               },
//                             );
//                           },
//                           error: (error, st) {
//                             return Center(
//                               child: Text(
//                                 error.toString(),
//                               ),
//                             );
//                           },
//                           loading: () => const Loader(),
//                         ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
// }
