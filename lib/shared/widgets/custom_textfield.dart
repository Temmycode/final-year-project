import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/colors/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final bool isPassword;
  final bool isEmail;
  final String hintText;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.isEmail = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.h,
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: AppColors.grey1,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        keyboardType: widget.isPassword
            ? TextInputType.text
            : widget.isEmail
                ? TextInputType.emailAddress
                : TextInputType.text,
        controller: widget.controller,
        obscureText: widget.isPassword && !isVisible ? true : false,
        obscuringCharacter: "*",
        style: TextStyle(
          fontSize: 16.spMin,
          fontWeight: FontWeight.w500,
          color: Colors.black, // AppColors.grey3,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return '';
          } else if (!widget.isPassword && widget.isEmail) {
            if ((RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) ==
                false) {
              return '';
            } else {
              return null;
            }
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffix: widget.isPassword
              ? GestureDetector(
                  onTap: () => setState(() => isVisible = !isVisible),
                  child: Text(
                    "Show",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16.spMin,
                    ),
                  ),
                )
              : null,
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
    );
  }
}
