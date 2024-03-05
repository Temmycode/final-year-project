import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/features/admin/screens/all_user_accounts_screen.dart';
import 'package:flutter_application_3/features/admin/screens/generate_student_qrcode_screen.dart';
import 'package:flutter_application_3/features/admin/screens/update_existing_users_screen.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/features/auth/screens/create_new_user_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdminActionsScreen extends ConsumerWidget {
  const AdminActionsScreen({super.key});

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
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.25),
        automaticallyImplyLeading: false,
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
        padding: EdgeInsets.symmetric(horizontal: 11.w),
        child: Consumer(builder: (context, ref, child) {
          return Column(
            children: [
              actionButton(
                "Create User Account",
                AppColors.primary,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CreateNewUserScreen(),
                  ),
                ),
              ),
              actionButton(
                "View All User Account(s)",
                AppColors.primary,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AllUserAccountsScreen(),
                    ),
                  );
                },
              ),
              actionButton(
                "Update User Account",
                AppColors.primary,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ExistingUserActionScreen(isDelete: false),
                    ),
                  );
                },
              ),
              actionButton(
                "Delete User Account",
                AppColors.red1,
                () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const ExistingUserActionScreen(isDelete: true),
                    ),
                  );
                },
              ),
              actionButton(
                "Generate Student QR",
                AppColors.primary,
                () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GenerateStudentQRcodeScreen(),
                    ),
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
