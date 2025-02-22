import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:client/features/home/view/screens/home_screen.dart';
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

  Future<void> _uploadImage({required String folderPath}) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dppvl48gh/upload');

    if (_imageFile != null) {
      final request = http.MultipartRequest("POST", url)
        ..fields['upload_preset'] = 'xzxyhatj'
        ..fields['folder'] = folderPath
        ..files
            .add(await http.MultipartFile.fromPath('file', _imageFile!.path));
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();

        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
          // log(,name: 'posts_image');

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
              ElevatedButton(
                onPressed: () {
                  _uploadImage(folderPath: "public/stories");
                },
                child: Text("Upload to cloudinary"),
              ),
              if(_imageFile != null) ...[
                Image.file(_imageFile!,fit: BoxFit.cover,
                                width: 150,
                                height: 150,),
              ],
                if (_imageUrl != null) ...[
                  Text("Cloudinary Url : $_imageUrl")
                ],
              ElevatedButton(
                onPressed: () async {
                  await ref.read(storyViewModelProvider.notifier).createStory(
                        selectedImage: _imageUrl!,
                        views: "view",
                      );
                      Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ),
              );
                },
                child: Text("Share Story"),
              ),
              ],

          ),
        ));
  }
}
