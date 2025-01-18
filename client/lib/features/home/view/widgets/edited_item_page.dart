// import 'package:client/features/home/repository/home_repository.dart';
// import 'package:flutter/material.dart';

// class EditItemPage extends StatelessWidget {
//   final int itemId;

//   EditItemPage(this.itemId);

//   final TextEditingController captionController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Edit Item")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: captionController,
//               decoration: InputDecoration(labelText: "Caption"),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await HomeRepository().editItem(itemId, captionController.text);
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text("Item updated!")),
//                 );
//               },
//               child: Text("Save Changes"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
