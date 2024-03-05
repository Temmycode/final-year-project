import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/config/images/app_images.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/models/student_model.dart';
import 'package:flutter_application_3/shared/widgets/primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StudentQRcodeActionScreen extends ConsumerWidget {
  final Student student;

  const StudentQRcodeActionScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = {
      "firstName": student.firstName,
      "lastName": student.lastName,
      "matricNo": student.matricNo,
      "department": student.department,
    };
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: CircleAvatar(
              child: Text(authState.user!.username.characters.first),
            ),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30.h),
              width: 247.w,
              height: 273.h,
              child: QrImageView(
                data: jsonEncode(userData),
                version: QrVersions.auto,
              ),
            ),
            SizedBox(height: 36.h),
            Text(
              "Student QR Code Successfully Generated",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.spMin,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 43.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppImages.share,
                      height: 41.h,
                      width: 41.h,
                    ),
                    Text(
                      "Share",
                      style: TextStyle(
                        fontSize: 22.spMin,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    )
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      AppImages.download,
                      height: 41.h,
                      width: 41.h,
                    ),
                    Text(
                      "Download",
                      style: TextStyle(
                        fontSize: 22.spMin,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    )
                  ],
                )
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: PrimaryButton(
                onTap: () => Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                ),
                title: "Done",
              ),
            )
          ],
        ),
      ),
    );
  }
}
