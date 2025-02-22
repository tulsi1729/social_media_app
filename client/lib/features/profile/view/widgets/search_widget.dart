import 'dart:convert';
import 'dart:developer';

import 'package:client/core/constants/server_constant.dart';
import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/follow/viewmodel/follow_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class SearchWidget extends ConsumerStatefulWidget {
  const SearchWidget({super.key});

  @override
  ConsumerState<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends ConsumerState<SearchWidget> {
  late Future<List<UserModel>> futureUsers;
  final Map<String, bool> followStatus = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    futureUsers = fetchUsers();
  }

  Future<List<UserModel>> fetchUsers() async {
    try {
      final token =
          ref.watch(currentUserNotifierProvider.select((user) => user!.token));

      final response = await http.get(
        Uri.parse('${ServerConstant.serverURL}/auth/get_user_lists'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token, // Sending Auth Token
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to load users: ${response.statusCode}");
      }

      final List<dynamic> resBodyMap = jsonDecode(response.body);
      return resBodyMap.map((user) => UserModel.fromMap(user)).toList();
    } catch (e) {
      log("Error fetching users: $e");
      throw Exception("Error fetching users");
    }
  }

  Future<void> toggleFollow(String userId) async {
    bool isCurrentlyFollowing = followStatus[userId] ?? false;

    if (isCurrentlyFollowing) {
      await ref
          .read(followViewModelProvider.notifier)
          .unFollowUser(targetUserId: userId);
    } else {
      await ref
          .read(followViewModelProvider.notifier)
          .followUser(targetUserId: userId);
    }

    // Update local follow status
    setState(() {
      followStatus[userId] = !isCurrentlyFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: EdgeInsets.all(8),
            color: Colors.grey.shade200,
            child: Row(
              children: const [
                Icon(
                  Icons.search,
                ),
                SizedBox(width: 10),
                Text(
                  "Search Users",
                ),
              ],
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No users found"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                // final isFollowing = followStatus[user.id] ?? false;
                final isFollowing = followStatus[user.id] ?? false;

                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  leading: CircleAvatar(child: Text(user.name[0])),
                  trailing: ElevatedButton(
                    onPressed: () => toggleFollow(user.id),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isFollowing ? Colors.red : Colors.blue,
                    ),
                    child: Text(isFollowing ? "UnFollow" : "Follow"),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
