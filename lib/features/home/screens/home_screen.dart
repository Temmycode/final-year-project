import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Activity Attendance",
          style: TextStyle(
            fontSize: 16.spMin,
          ),
        ),
      ),
      body: Column(
        children: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
