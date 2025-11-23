import 'dart:developer';

import 'package:client/core/providers/current_user_notifier.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/pages/signup_page.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/features/home/view/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    return MaterialApp(
      title: 'Social Media App',
      home: ScreenUtilInit(
        designSize: Size(375, 812),
        // child: currentUser == null ? SignupPage() : DashboardScreen(),
        child: LoginPage(),
      ),
    );
  }
}
