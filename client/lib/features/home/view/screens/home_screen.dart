import 'dart:developer';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserNotifierProvider);
    log(user.toString(), name: 'Home');

    return Center(child: Text("Home Page "));
  }
}
