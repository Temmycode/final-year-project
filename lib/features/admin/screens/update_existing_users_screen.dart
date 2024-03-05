import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/features/admin/screens/update_user_details_screen.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/features/auth/providers/get_all_existing_users_provider.dart';
import 'package:flutter_application_3/models/user_model.dart';
import 'package:flutter_application_3/shared/widgets/primary_button.dart';
import 'package:flutter_application_3/shared/widgets/secondary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExistingUserActionScreen extends ConsumerWidget {
  final bool isDelete;

  const ExistingUserActionScreen({super.key, required this.isDelete});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);
    final allExistingUsers = ref.watch(getAllExistingUsersProvider);

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
        title: Text(
          "Existing User",
          style: TextStyle(
            fontSize: 16.spMin,
            fontWeight: FontWeight.w500,
          ),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: allExistingUsers.when(
            data: (users) {
              return Column(
                children: [
                  SizedBox(height: 17.h),
                  Text(
                    isDelete ? "Delete Existing User" : "Update Existing User",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 30.spMin,
                    ),
                  ),
                  SizedBox(height: 35.h),
                  users.isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          width: double.maxFinite,
                          height: MediaQuery.sizeOf(context).height -
                              5 * kBottomNavigationBarHeight,
                          child: const Text("No Users Yet"),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: users
                              .length, // this should be the length of the numbers from the database
                          itemBuilder: (context, index) {
                            final user = users[index];

                            return userContainer(context, ref, user);
                          },
                        )
                ],
              );
            },
            loading: () => const CircularProgressIndicator.adaptive(
              backgroundColor: Colors.white,
            ),
            error: (error, stk) => throw Exception(error),
          ),
        ),
      ),
    );
  }

  Widget userContainer(BuildContext context, WidgetRef ref, UserModel user) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(8.r),
        onTap: () {
          if (!isDelete) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateUserDetailsScreen(user: user),
              ),
            );
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  backgroundColor: Colors.white,
                  surfaceTintColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 32.h,
                  ),
                  title: Text(
                    "Are You Sure You Want to Delete this Account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 28.spMin,
                    ),
                  ),
                  children: [
                    Column(
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
                              ": ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.spMin,
                                color: AppColors.grey4,
                              ),
                            ),
                            Text(
                              user.username,
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
                              "Staff ID",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.spMin,
                                color: AppColors.grey4,
                              ),
                            ),
                            Text(
                              ": ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.spMin,
                                color: AppColors.grey4,
                              ),
                            ),
                            Text(
                              user.staffId,
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
                              "Email",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.spMin,
                                color: AppColors.grey4,
                              ),
                            ),
                            Text(
                              ": ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16.spMin,
                                color: AppColors.grey4,
                              ),
                            ),
                            Text(
                              user.email,
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
                    SizedBox(height: 40.h),
                    PrimaryButton(
                      isLoading: ref.watch(authStateNotifierProvider).isLoading,
                      onTap: () async {
                        await ref
                            .read(authStateNotifierProvider.notifier)
                            .deleteUserDetails(user)
                            .whenComplete(
                              () => Navigator.pop(context),
                            );
                        // ignore: unused_result
                        ref.refresh(getAllExistingUsersProvider);
                      },
                      title: "Yes",
                    ),
                    SizedBox(height: 10.h),
                    SecondaryButton(
                      color: AppColors.red1,
                      onTap: () => Navigator.pop(context),
                      title: "No",
                    )
                  ],
                );
              },
            );
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.h),
          height: 50.h,
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: AppColors.primary,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                user.username,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.spMin,
                  color: Colors.white,
                ),
              ),
              Text(
                user.staffId,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16.spMin,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
