import 'dart:io';

import 'package:client/core/utils.dart';
import 'package:client/features/home/models/post_model.dart';
import 'package:client/features/home/view/screens/profile_screen.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  final bool isEditMode;
  final PostModel? preFilledPost;
  const CreatePostScreen({
    super.key,
    this.isEditMode = false,
    this.preFilledPost,
  });

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final TextEditingController captionController = TextEditingController();
  File? selectedImage;
  final formKey = GlobalKey<FormState>();
  // final ImagePicker imagePicker = ImagePicker();
  // List<XFile>? imageFileList = [];

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      captionController.text = widget.preFilledPost!.caption;
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  // void selectedImage() async {
  //   final List<XFile> selectedImages = await imagePicker.pickMultiImage();
  //   if (selectedImages.isNotEmpty) {
  //     imageFileList!.addAll(selectedImages);
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? "Edit Post" : "Create Post "),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                child: Stack(clipBehavior: Clip.none, children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    if (selectedImage != null) {
                      selectImage();
                    }
                  },
                  child: selectedImage != null
                      ? SizedBox(
                          height: 150,
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                          ),
                          child: const SizedBox(
                            height: 150,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.folder_open,
                                  size: 40,
                                ),
                                SizedBox(height: 15),
                                Text(
                                  'Select the Image for your Post',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                ),
              ),
              Positioned(
                top: -24,
                right: -24,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      selectedImage = null;
                    });
                  },
                  icon: const Icon(
                    Icons.cancel,
                    size: 28,
                  ),
                ),
              ),
            ])),
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
                if (selectedImage != null) {
                  if (widget.isEditMode) {
                    ref.read(homeViewModelProvider.notifier).editedPost(
                          caption: captionController.text,
                          selectedPostMedia: selectedImage!,
                          postId: widget.preFilledPost!.id,
                        );
                    Navigator.pop(context);
                  } else {
                    ref.read(homeViewModelProvider.notifier).uploadPost(
                          caption: captionController.text,
                          selectedPostMedia: selectedImage!,
                        );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  }
                }
              },
              child: Text(widget.isEditMode ? "Edit Post" : "Create Post "),
            ),
          ],
        ),
      ),
    );
  }
}
