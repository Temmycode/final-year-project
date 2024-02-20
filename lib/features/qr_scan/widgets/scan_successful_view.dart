import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/shared/widgets/primary_button.dart';
import 'package:flutter_application_3/shared/widgets/secondary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScanSuccessfulView extends ConsumerWidget {
  const ScanSuccessfulView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Ink(
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 32.h,
      ),
      height: 363.h,
      width: 343.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                "Scan Successful",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 30.sp,
                ),
              ),
              SizedBox(height: 45.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.spMin,
                          color: AppColors.grey4,
                        ),
                      ),
                      Text(
                        ":",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.spMin,
                          color: AppColors.grey4,
                        ),
                      ),
                      Text(
                        "John Doe",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.spMin,
                          color: AppColors.grey4,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.spMin,
                          color: AppColors.grey4,
                        ),
                      ),
                      Text(
                        ":",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.spMin,
                          color: AppColors.grey4,
                        ),
                      ),
                      Text(
                        "John Doe",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.spMin,
                          color: AppColors.grey4,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.spMin,
                          color: AppColors.grey4,
                        ),
                      ),
                      Text(
                        ":",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.spMin,
                          color: AppColors.grey4,
                        ),
                      ),
                      Text(
                        "John Doe",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16.spMin,
                          color: AppColors.grey4,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 40.h),
          PrimaryButton(
            onTap: () {},
            title: "Next Student",
          ),
          SecondaryButton(onTap: () {}, title: "DONE"),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }
}
