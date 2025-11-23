import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/home/view/screens/my_posts_screen.dart';
import 'package:client/features/home/view/widgets/profile_widget.dart';
import 'package:client/features/home/view/widgets/user_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            UserNameWidget(),
          ],
        ),
        actions: [
          // IconButton(
          //   onPressed: () {
          //     Navigator.of(context).push(
          //       MaterialPageRoute(
          //         builder: (context) => CreateAllScreen(),
          //       ),
          //     );
          //   },
          //   icon: Icon(Icons.add),
          // ),
          IconButton(onPressed: (){
             Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              );
          }, icon: Icon(Icons.logout),),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: ProfileWidget(),
            ),
        const SizedBox(height: 10),
            //my posts
            Flexible(
              flex: 3,
              child: MyPostsScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
