import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AllUserProfile extends ConsumerWidget {
  const AllUserProfile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getAllUserProvider).when(
      data: (users){
      return Column(
        children: [
          CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(users.first.profileImage ?? ''),
          ),
          Text(users.first.userName ?? "unknown user",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,
          ),
         ),
        ],
      );
    }, error: (error,str){
      return Center(
        child: Text(error.toString()),
      );
    }, loading: () => Loader());
  }
}