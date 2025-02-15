import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/view/widgets/custom_field.dart';
import 'package:client/features/home/view/screens/profile_screen.dart';
import 'package:client/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditProfile extends ConsumerStatefulWidget {
  final bool isEditMode;
  final UserModel? preFilledProfile;
  const EditProfile(
      {super.key, this.isEditMode = false, this.preFilledProfile});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  File? _imageFile;
  String? _imageUrl;
  final bioController = TextEditingController();
  final userNameController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) _imageFile = File(pickedFile.path);
    });

    await _uploadImage();
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
  void initState() {
    super.initState();
    if (widget.isEditMode && widget.preFilledProfile != null) {
      bioController.text = widget.preFilledProfile!.bio ?? '';
      userNameController.text = widget.preFilledProfile!.userName ?? '';
      setState(() {
        _imageUrl = widget.preFilledProfile!.profileImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          CustomField(
            hintText: "User Name",
            labelText: "User Name",
            controller: userNameController,
          ),
          CustomField(
              hintText: "Bio", labelText: "Bio", controller: bioController),
          SizedBox(
            height: 20,
          ),

          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 120,
            width: 120,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: _imageFile != null
                      ? FileImage(_imageFile!) // Show newly selected image
                      : (_imageUrl != null && _imageUrl!.isNotEmpty
                          ? NetworkImage(
                              _imageUrl!) // Show pre-filled profile image
                          : const AssetImage('assets/default_profile.png')
                              as ImageProvider), // Show default image if none exists
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.blue),
                    onPressed: () {
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),

          // ElevatedButton(
          //   onPressed: () {
          //     _uploadImage();
          //   },
          //   child: Text("Upload to cloudinary"),
          // ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(profileViewModelProvider.notifier).editUser(
                    selectedProfileImage: _imageUrl ??
                        widget.preFilledProfile?.profileImage ??
                        '',
                    bio: bioController.text,
                    userName: userNameController.text,
                    id: ref.read(currentUserNotifierProvider)!.id,
                  );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            child: Text("Save Profile"),
          ),
        ]),
      ),
    );
  }
}
