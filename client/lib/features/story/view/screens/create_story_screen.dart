import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:client/features/story/viewmodel/story_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CreateStoryScreen extends ConsumerStatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  ConsumerState<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends ConsumerState<CreateStoryScreen> {
  File? _imageFile;
  String? _imageUrl;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) _imageFile = File(pickedFile.path);
    });
  }

  Future<void> _uploadImage() async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dppvl48gh/upload');

    if (_imageFile != null) {
      final request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = 'xzxyhatj'
        ..files
            .add(await http.MultipartFile.fromPath('file', _imageFile!.path));
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();

        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        setState(() {
          final url = jsonMap['url'];
          _imageUrl = url;
          log(_imageUrl.toString(), name: "imageurl setstate");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create Story"),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                },
                child: Text("select from gallery"),
              ),
              if (_imageFile != null)
                if (_imageUrl != null) ...[
                  Image.network(_imageUrl!),
                  Text("Cloudinary Url : $_imageUrl")
                ],
              ElevatedButton(
                onPressed: () {
                  _uploadImage();
                },
                child: Text("Upload to cloudinary"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await ref.read(storyViewModelProvider.notifier).createStory(
                        selectedImage: _imageUrl!,
                        views: "view",
                      );
                },
                child: Text("Share Story"),
              ),
            ],
          ),
        ));
  }
}
