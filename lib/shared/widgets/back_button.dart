import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/config/images/app_images.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class CustomBackButton extends StatelessWidget {
  final Color? color;

  const CustomBackButton({
    super.key,
    this.color = AppColors.backButton,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(56.r),
      child: Container(
        alignment: Alignment.center,
        height: 56.h,
        width: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(56.r),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
            ),
          ],
        ),
        child: SvgPicture.asset(
          AppImage.backButton,
          height: 24.h,
          width: 24.h,
          fit: BoxFit.cover,
          color: color,
        ),
      ),
    );
  }
}
