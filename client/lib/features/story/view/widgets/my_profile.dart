import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:client/features/story/view/screens/create_story_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyProfile extends ConsumerWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getMyUserProvider).when(
      data: (users) {
        return Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(users.first.profileImage ?? ''),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CreateStoryScreen(),
                      ),
                    );
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 245, 247, 249), // Change the color as needed
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2,),
                      ),
                      child: Icon(
                        Icons.add,
                        color: const Color.fromARGB(255, 7, 7, 7),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              "My Story",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
      error: (error, str) {
        return Center(
          child: Text(error.toString()),
        );
      },
      loading: () => Loader(),
    );
  }
}
