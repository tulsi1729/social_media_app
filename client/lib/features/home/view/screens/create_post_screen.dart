import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:client/features/home/models/post_model.dart';
import 'package:client/features/home/view/screens/profile_screen.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

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
  final formKey = GlobalKey<FormState>();
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  String? uploadedImageUrl;
  XFile? selectedImageUrl;
  String? commaSeparatedUrl;

  @override
  void initState() {
    super.initState();
    if (widget.isEditMode) {
      captionController.text = widget.preFilledPost!.caption;
      if (widget.preFilledPost!.imageUrl.isNotEmpty) {
        List<String> existingImages = widget.preFilledPost!.imageUrl.split(",");
        setState(() {
          uploadedImageUrl = widget.preFilledPost!.imageUrl;
          imageFileList = existingImages.map((url) => XFile(url)).toList();
        });
      }
    }
  }

  void selectedImage() async {
    try {
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      if (selectedImages != null && selectedImages.isNotEmpty) {
        setState(() {
          imageFileList!.addAll(selectedImages);
        });
      }
    } catch (e) {
      print('Error selecting images: $e');
    }
  }

  Future<void> _uploadImage() async {
    if (imageFileList == null || imageFileList!.isEmpty) {
      log('No images selected.');
      return;
    }
    List<String> uploadedUrls = [];

    try {
      for (XFile image in imageFileList!) {
        if (image.path.startsWith("http") || image.path.startsWith("https")) {
          uploadedUrls.add(image.path); // Keep existing Cloudinary images
          continue; // Skip re-uploading already uploaded images
        }

        final url =
            Uri.parse('https://api.cloudinary.com/v1_1/dppvl48gh/upload');
        final request = http.MultipartRequest("POST", url)
          ..fields['upload_preset'] = 'xzxyhatj'
          ..files.add(await http.MultipartFile.fromPath('file', image.path));

        final response = await request.send();
        if (response.statusCode == 200) {
          final responseData = await response.stream.toBytes();

          final responseString = String.fromCharCodes(responseData);
          final jsonMap = jsonDecode(responseString);
          final uploadedImageUrl = jsonMap['secure_url'];

          uploadedUrls.add(uploadedImageUrl);

          log('Image uploaded: $uploadedImageUrl');
        } else {
          log('Failed to upload image. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
    commaSeparatedUrl = uploadedUrls.join(",");
    log(commaSeparatedUrl.toString(), name: " comma separate url");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? "Edit Post" : "Create Post"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                selectedImage();
              },
              child: Text("select from gallery"),
            ),
            if (imageFileList != null)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: imageFileList!.length,
                  itemBuilder: (context, index) {
                    String imagePath = imageFileList![index].path;
                    bool isNetworkImage = imagePath.startsWith("http") ||
                        imagePath.startsWith("https");

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          isNetworkImage
                              ? Image.network(
                                  imagePath,
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                )
                              : Image.file(
                                  File(imagePath),
                                  fit: BoxFit.cover,
                                  width: 150,
                                  height: 150,
                                ),
                          Positioned(
                            top: -24,
                            right: -24,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  imageFileList?.removeAt(index);
                                });
                              },
                              icon: const Icon(
                                Icons.cancel,
                                size: 28,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ElevatedButton(
              onPressed: () {
                _uploadImage();
              },
              child: Text("Upload to cloudinary"),
            ),
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
                if (commaSeparatedUrl != null) {
                  if (widget.isEditMode) {
                    final editedPost =
                        ref.read(homeViewModelProvider.notifier).editedPost(
                              caption: captionController.text,
                              selectedImage: commaSeparatedUrl!,
                              postId: widget.preFilledPost!.id,
                            );
                    log(editedPost.toString(), name: "create in  edit ");

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  } else {
                    await ref.read(homeViewModelProvider.notifier).createPost(
                          caption: captionController.text,
                          selectedImage: commaSeparatedUrl!,
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
              child: Text(widget.isEditMode ? "Edit Post" : "Create Post"),
            ),
          ],
        ),
      ),
    );
  }
}
