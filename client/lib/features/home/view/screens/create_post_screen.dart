import 'package:flutter/material.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  // XFile? selectedXFile;
  @override
  Widget build(BuildContext context) {
    final captionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create post"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //       color: Colors.red,
            //     ),
            //   ),
            //   child: SizedBox(
            //     height: 200,
            //     child: selectedXFile != null
            //         ? Stack(clipBehavior: Clip.none, children: [
            //             Container(
            //               decoration: BoxDecoration(
            //                 border: Border.all(
            //                   color: Colors.black,
            //                 ),
            //               ),
            //               child: Image.file(
            //                 File(selectedXFile!.path),
            //               ),
            //             ),
            //             Positioned(
            //               top: -24,
            //               right: -24,
            //               child: IconButton(
            //                 onPressed: () {
            //                   setState(() {
            //                     selectedXFile = null;
            //                   });
            //                 },
            //                 icon: const Icon(
            //                   Icons.cancel,
            //                   size: 28,
            //                 ),
            //               ),
            //             ),
            //           ])
            //         : GestureDetector(
            //             onTap: _onPressedSelectMedia,
            //             child: const Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Text("Select Media"),
            //                 SizedBox(
            //                   width: 5,
            //                 ),
            //                 Icon(Icons.arrow_upward)
            //               ],
            //             ),
            //           ),
            //   ),
            // ),
            // Image.asset("assets/animal.jpg"),
            const SizedBox(
              height: 12,
            ),
            TextField(
              controller: captionController,
              decoration: const InputDecoration(
                hintText: 'caption',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () async {
                // await createdPost();
                // resetInputFields();
              },
              child: const Text("Create Post"),
            ),
          ],
        ),
      ),
    );
  }
}
