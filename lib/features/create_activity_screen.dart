import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/config/images/app_images.dart';
import 'package:flutter_application_3/features/database/local_database_client.dart';
import 'package:flutter_application_3/models/activity_model.dart';
import 'package:flutter_application_3/shared/widgets/primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateActivityScreen extends ConsumerWidget {
  final String type;

  const CreateActivityScreen({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(createNewActivityControllerProvider);
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
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: 24.h,
            left: 25.w,
            right: 25.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "Create New Activity",
                  style: TextStyle(
                    fontSize: 30.spMin,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 68.h),
              Container(
                alignment: Alignment.center,
                height: 44.h,
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: AppColors.grey1,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: TextFormField(
                  controller: controller,
                  cursorHeight: 30.h,
                  style: TextStyle(
                    fontSize: 16.spMin,
                    fontWeight: FontWeight.w600,
                    color: Colors.black, // AppColors.grey3,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return '';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Enter Your Activity Title",
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                    hintStyle: TextStyle(
                      fontSize: 16.spMin,
                      fontWeight: FontWeight.w500,
                      color: AppColors.grey3,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: const BorderSide(
                        color: AppColors.grey2,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: Colors.red.shade800),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide: BorderSide(color: Colors.red.shade800),
                    ),
                    errorStyle: const TextStyle(fontSize: 0),
                  ),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                onTap: () async {
                  final activity = Activity(
                    title: controller.text,
                    type: type,
                    imageUrl: AppImage.hall,
                  );
                  await LocalDatabaseClient.createActivity(
                    activity: activity,
                  ).whenComplete(() => Navigator.pop(context));
                },
                title: "Create",
              )
            ],
          ),
        ),
      ),
    );
  }
}

final createNewActivityControllerProvider = Provider(
  (ref) => TextEditingController(),
);
