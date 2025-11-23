import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/home/view/screens/edit_profile.dart';
import 'package:client/features/home/view/widgets/post_count_widget.dart';
import 'package:client/features/profile/view/widgets/follow_count_widget.dart';
import 'package:client/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileWidget extends ConsumerStatefulWidget {
  const ProfileWidget({super.key});

  @override
  ConsumerState<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends ConsumerState<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(getMyUserProvider).when(
          data: (profile) {
            return ListView.builder(
              itemCount: profile.length,
              itemBuilder: (context, index) {
                final profileItem = profile[index];
                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          profileItem.profileImage != null
                              ? CircleAvatar(
                                  radius: 31,
                                  backgroundImage: (profileItem
                                                  .profileImage !=
                                              null &&
                                          profileItem
                                              .profileImage!.isNotEmpty
                                      ? NetworkImage(
                                          profileItem.profileImage!)
                                      : const AssetImage(
                                              'assets/default_profile.png')
                                          as ImageProvider),
                                )
                              : Text("No image selected"),
                
                          // Posts, Followers, Followings
                
                          Column(
                            children: [
                              PostCountWidget(),
                            ],
                          ),
                          Column(
                            children: [
                              FollowCountWidget(),
                            ],
                          ),
                        ],
                      ),
                
                      // Name & Bio
                      const SizedBox(height: 5),
                      profileItem.userName != null
                          ? Text(
                              profileItem.userName!,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text("No user name"),
                      profileItem.bio != null
                          ? Text(
                              profileItem.bio!,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text("No Bio"),
                      // Edit Profile Section
                      SafeArea(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProfile(
                                      isEditMode: true,
                                      preFilledProfile: profileItem,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 16),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          const Color.fromARGB(255, 6, 5, 5)),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //       vertical: 8, horizontal: 16),
                            //   decoration: BoxDecoration(
                            //     border: Border.all(
                            //         color:
                            //             const Color.fromARGB(255, 6, 5, 5)),
                            //     borderRadius: BorderRadius.circular(8),
                            //   ),
                            //   child: Text(
                            //     "Share Profile",
                            //     style: TextStyle(
                            //         fontSize: 16,
                            //         fontWeight: FontWeight.w500),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          error: (error, st) {
            return Center(
              child: Text(
                error.toString(),
              ),
            );
          },
          loading: () => const Loader(),
        );
  }
}
