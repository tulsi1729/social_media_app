import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:client/features/home/view/screens/reels_screen.dart';
import 'package:client/features/reel/viewmodel/reel_viewmodel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class CreateReelScreen extends ConsumerStatefulWidget {
  const CreateReelScreen({
    super.key,
  });

  @override
  ConsumerState<CreateReelScreen> createState() => _CreateReelScreenState();
}

class _CreateReelScreenState extends ConsumerState<CreateReelScreen> {
  final TextEditingController captionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  PlatformFile? pickedFile;
  File? videoFile;
  String? uploadedVideoUrl;
  bool isUploading = false;
  VideoPlayerController? _videoController;

  void _initializeVideo() {
    if (videoFile == null) return;

    _videoController = VideoPlayerController.file(videoFile!)
      ..initialize().then((_) {
        setState(() {});
        _videoController!.play();
      });
  }

  Future<void> selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
      videoFile = File(pickedFile!.path!); // Convert to File
    });

    _initializeVideo();
  }

  Future<void> uploadVideo() async {
    if (videoFile == null) {
      log('No video selected.');
      return;
    }

    setState(() {
      isUploading = true;
    });

    final url =
        Uri.parse('https://api.cloudinary.com/v1_1/dppvl48gh/video/upload');

    var request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = 'xzxyhatj'
      ..fields['folder'] = "public/reels"
      ..files.add(await http.MultipartFile.fromPath('file', videoFile!.path));

    try {
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonMap = jsonDecode(responseData);

        if (jsonMap.containsKey('secure_url')) {
          setState(() {
            uploadedVideoUrl =
                jsonMap['secure_url']; // Valid URL from Cloudinary
          });
          log('Uploaded Video URL: $uploadedVideoUrl');
        } else {
          log('Invalid response from Cloudinary: $jsonMap');
        }
      } else {
        log('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      log('Error uploading video: $e');
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Reel"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                selectFile();
              },
              child: Text("select from gallery"),
            ),

            // Display Video Player when video is selected
            if (_videoController != null &&
                _videoController!.value.isInitialized)
              Column(
                children: [
                  SizedBox(
                    height: 300,
                    width: 400,
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(
                          _videoController!.value.isPlaying
                            ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        onPressed: () {
                          setState(() {
                            _videoController!.value.isPlaying
                                ? _videoController!.pause()
                                : _videoController!.play();
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ElevatedButton(
              onPressed: isUploading ? null : uploadVideo,
              child: isUploading
                  ? const CircularProgressIndicator()
                  : const Text("Upload to Cloudinary"),
            ),
            if (uploadedVideoUrl != null)
              SelectableText(
                "Video Uploaded: $uploadedVideoUrl",
                style: const TextStyle(color: Colors.blue),
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
                if (uploadedVideoUrl != null) {
                  await ref.read(reelViewModelProvider.notifier).createReel(
                        caption: captionController.text,
                        selectedVideo: uploadedVideoUrl!,
                      );
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReelsScreen(),
                  ),
                );
              },
              child: Text("Create Reel"),
            ),
          ],
        ),
      ),
    );
  }
}
