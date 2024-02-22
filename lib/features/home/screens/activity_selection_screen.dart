import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/features/database/local_database_client.dart';
import 'package:flutter_application_3/features/database/providers/get_activity_provider.dart';
import 'package:flutter_application_3/shared/widgets/scan_qr_code_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivitySelectionScreen extends ConsumerWidget {
  final String title;
  final String type;

  const ActivitySelectionScreen({
    super.key,
    required this.title,
    required this.type,
  });

  Widget actionButton(String title, Color color, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          height: 72.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16.spMin,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.25),
        leading: CupertinoButton(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            weight: 0.5,
          ),
          onPressed: () => Navigator.pop(context),
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
            child: const CircleAvatar(
              child: Text("M"),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 11.w),
        child: Consumer(builder: (context, ref, child) {
          return Column(
            children: [
              actionButton(
                "Take Attendance",
                AppColors.primary,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScanQrCodeView(title: title),
                  ),
                ),
              ),
              actionButton(
                "Generate Report",
                AppColors.primary,
                () async {},
              ),
              actionButton(
                "Delete Activity",
                AppColors.red1,
                () async {
                  await LocalDatabaseClient.deleteActivity(title: title)
                      .whenComplete(
                    () {
                      Navigator.popUntil(
                        context,
                        (route) => route.isFirst,
                      ); // here i am popping back to the first screen
                      // ignore: unused_result
                      ref.refresh(
                        getActivityProvider(type),
                      ); // refresh the information from the database to be up to date
                    },
                  );
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}
