import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/cloud/services/cloud_serives.dart';
import 'package:flutter_application_3/config/images/app_images.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/features/database/local_database_client.dart';
import 'package:flutter_application_3/features/home/screens/activity_screen.dart';
import 'package:flutter_application_3/helpers/loading_screen.dart';
import 'package:flutter_application_3/shared/widgets/activity_cards.dart';
import 'package:flutter_application_3/shared/widgets/snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isCloudLoading = false;
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.25),
        leading: CupertinoButton(
          child: SvgPicture.asset(AppImages.syncToCloud),
          onPressed: () async {
            setState(() => isCloudLoading = true);
            LoadingScreen.instance().show(context: context);
            final activities = await LocalDatabaseClient.getAllACtivities();
            final attendances = await LocalDatabaseClient.getAllAttendances();
            final attendanceStudents =
                await LocalDatabaseClient.getAllAttendanceStudents();
            final students = await LocalDatabaseClient.getAllStudents();
            try {
              if (activities.isNotEmpty ||
                  attendances.isNotEmpty ||
                  students.isNotEmpty ||
                  attendanceStudents.isNotEmpty) {
                await CloudServices.backupToCloud(
                  staffId: authState.user!.staffId,
                  activities: activities,
                  attendances: attendances,
                  attendanceStudents: attendanceStudents,
                  students: students,
                );
              } else {
                // ignore: use_build_context_synchronously
                displaySnack(context, text: "No Entry in your database yet");
              }
            } catch (e) {
              // ignore: use_build_context_synchronously
              displaySnack(context, text: e.toString());
              debugPrint(e.toString());
            } finally {
              setState(() => isCloudLoading = false);
              LoadingScreen.instance().hide();
              // ignore: use_build_context_synchronously
              displaySnack(context, text: "Successfully Backedup to Cloud");
            }
          }, // upload to cloud function
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
                image: AppImages.classroom,
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
                image: AppImages.hall,
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
                image: AppImages.chapel,
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
                image: AppImages.interdisciplinary,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          ref.read(authStateNotifierProvider.notifier).logout(context);
        },
        child: const Icon(Icons.logout),
      ),
    );
  }
}
