import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/images/app_images.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/features/home/screens/classroom_screen.dart';
import 'package:flutter_application_3/shared/widgets/activity_cards.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.25),
        leading: CupertinoButton(
          child: const Icon(
            Icons.menu,
            color: Colors.black,
            weight: 0.5,
          ),
          onPressed: () {},
        ),
        title: Text(
          "Activity Attendance",
          style: TextStyle(
            fontSize: 16.spMin,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: CircleAvatar(
              child: Text(authState.user!.username.characters.first),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 11.w),
          child: Column(
            children: [
              ActivityCards(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ActivityScreen(
                      title: "Classroom Attendance",
                      type: "classroom",
                    ),
                  ),
                ),
                title: "Classroom Attendance",
                image: AppImage.classroom,
              ),
              ActivityCards(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ActivityScreen(
                      title: "Hall Assembly Attendance",
                      type: "hall",
                    ),
                  ),
                ),
                title: "Hall Assembly Attendance",
                image: AppImage.hall,
              ),
              ActivityCards(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ActivityScreen(
                      title: "Chapel Attendance",
                      type: "chapel",
                    ),
                  ),
                ),
                title: "Chapel Attendance",
                image: AppImage.chapel,
              ),
              ActivityCards(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ActivityScreen(
                      title: "Interdisciplinary Seminar",
                      type: "seminar",
                    ),
                  ),
                ),
                title: "Interdisciplinary Seminar",
                image: AppImage.interdisciplinary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
