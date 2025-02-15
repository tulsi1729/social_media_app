import 'package:client/features/auth/view/widgets/loader.dart';
import 'package:client/features/profile/viewmodel/profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserNameWidget extends ConsumerStatefulWidget {
  const UserNameWidget({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserNameWidgetState();
}

class _UserNameWidgetState extends ConsumerState<UserNameWidget> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(getUserProvider).when(
          data: (profile) {
            return Text(
              profile.isNotEmpty
                  ? profile.first.userName ?? 'Profile'
                  : 'Profile',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            );
          },
          error: (error, _) => Center(
            child: Text(error.toString()),
          ),
          loading: () => Loader(),
        );
  }
}
