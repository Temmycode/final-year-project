import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/colors/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final bool? isLoading;
  final VoidCallback? onTap;

  const PrimaryButton({
    super.key,
    required this.title,
    this.isLoading = false,
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
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: Center(
          child: isLoading!
              ? const CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                )
              : Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.spMin,
                  ),
                ),
        ),
      ),
    );
  }
}
