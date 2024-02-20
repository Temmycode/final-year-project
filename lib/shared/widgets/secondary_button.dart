import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SecondaryButton({
    super.key,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(100.r),
      onTap: onTap,
      child: Ink(
        height: 51.h,
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              fontSize: 16.spMin,
            ),
          ),
        ),
      ),
    );
  }
}
