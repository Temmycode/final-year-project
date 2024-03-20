import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';

displaySnack(
  BuildContext context, {
  required String text,
  Color? color,
}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: color ?? AppColors.primary,
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}
