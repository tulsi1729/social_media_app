import 'dart:developer';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/create/dashboard_screen.dart';
import 'package:client/features/home/view/screens/create_post_screen.dart';
import 'package:client/features/home/view/screens/posts_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final container = ProviderContainer();

  await container.read(authViewModelProvider.notifier).initSharedPreferences();
  final user = await container.read(authViewModelProvider.notifier).getData();
  log(user.toString(), name: "user");

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      title: 'Spotify App',
      home: currentUser == null ? SignupPage() : DashboardScreen(),
    );
  }
}
