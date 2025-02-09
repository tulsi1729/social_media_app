import 'package:client/features/profile/view/widgets/follow_count_widget.dart';
import 'package:client/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends ConsumerWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getFollowCountProvider).when(
          data: (follows) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color.fromARGB(255, 229, 160, 236)),
                      ),

                      // Posts, Followers, Followings
                      Column(
                        children: [
                          Text(
                            "0",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          Text("Posts"),
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
                  const SizedBox(height: 16),
                  Text(
                    "Hey hello",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  Text("I create apps"),

                  // Edit Profile Section
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(child: Text("Edit Profile")),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(child: Text("Ad Tools")),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(child: Text("Insights")),
                        ),
                      ),
                    ],
                  ),

                  // Profile Pictures Section
                  // const SizedBox(height: 20),
                  // Row(
                  //   children: List.generate(
                  //     3,
                  //     (index) => Padding(
                  //       padding: const EdgeInsets.only(right: 10),
                  //       child: CircleAvatar(radius: 50),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
          error: (error, _) => Center(child: Text(error.toString())),
          loading: () => const Loader(),
        );
  }
}
