import 'package:client/features/reel/view/screens/create_reel_screen.dart';
import 'package:client/features/home/view/add_screen/create_post_screen.dart';
import 'package:client/features/story/view/screens/create_story_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  int _currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  onPageChanged(int page) {
    setState(() {
      _currentIndex = page;
    });
  }

  navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView(
              controller: pageController,
              onPageChanged: onPageChanged,
              children: const [
                CreatePostScreen(),
                CreateStoryScreen(),
                CreateReelScreen(),
              ],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: 10.h,
              right: _currentIndex == 1 ? 100.w : 120.w,
              child: Container(
                width: 150.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        navigationTapped(0);
                      },
                      child: Text(
                        'Post',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color:
                              _currentIndex == 0 ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        navigationTapped(1);
                      },
                      child: Text(
                        'Story',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color:
                              _currentIndex == 1 ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        navigationTapped(2);
                      },
                      child: Text(
                        'Reels',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                          color:
                              _currentIndex == 2 ? Colors.white : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
