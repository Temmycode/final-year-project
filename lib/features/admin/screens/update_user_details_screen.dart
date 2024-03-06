import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/config/images/app_images.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/features/auth/providers/get_all_existing_users_provider.dart';
import 'package:flutter_application_3/models/user_model.dart';
import 'package:flutter_application_3/shared/widgets/custom_textfield.dart';
import 'package:flutter_application_3/shared/widgets/primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class UpdateUserDetailsScreen extends ConsumerStatefulWidget {
  final UserModel user;

  const UpdateUserDetailsScreen({super.key, required this.user});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateUserDetailsScreenState();
}

class _UpdateUserDetailsScreenState
    extends ConsumerState<UpdateUserDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _staffIdController;
  bool isUpdated = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _staffIdController = TextEditingController(text: widget.user.staffId);
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _staffIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 23.w),
            child: isUpdated
                ? SizedBox(
                    height: MediaQuery.sizeOf(context).height -
                        kToolbarHeight -
                        kBottomNavigationBarHeight,
                    width: double.maxFinite,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ... image
                        SvgPicture.asset(AppImages.success),
                        SizedBox(height: 50.h),
                        Text(
                          "New User Successfully Created",
                          style: TextStyle(
                            fontSize: 22.spMin,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                        SizedBox(height: 50.h),
                        PrimaryButton(
                          onTap: () => Navigator.popUntil(
                            context,
                            (route) => route.isFirst,
                          ),
                          title: "Done",
                        )
                      ],
                    ),
                  )
                : Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(bottom: 40.h, top: 66.h),
                        child: Text(
                          "Create New User",
                          style: TextStyle(
                            fontSize: 36.spMin,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _usernameController,
                              hintText: "Full Name",
                            ),
                            SizedBox(height: 30.h),
                            CustomTextField(
                              controller: _emailController,
                              hintText: "Email",
                              isEmail: true,
                            ),
                            SizedBox(height: 30.h),
                            CustomTextField(
                              controller: _staffIdController,
                              hintText: "Staff ID",
                            ),
                          ],
                        ),
                      ),

                      // the login button
                      Padding(
                        padding: EdgeInsets.only(bottom: 45.h, top: 200.h),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final authState =
                                ref.watch(authStateNotifierProvider);
                            return PrimaryButton(
                              onTap: () async {
                                final updatedUser = UserModel(
                                  email: _emailController.text,
                                  username: _usernameController.text,
                                  staffId: _staffIdController.text,
                                  isAdmin: false,
                                );

                                if (_emailController.text.isNotEmpty ||
                                    _usernameController.text.isNotEmpty ||
                                    _staffIdController.text.isNotEmpty) {
                                  // update user
                                  await ref
                                      .read(authStateNotifierProvider.notifier)
                                      .updateUserDetails(updatedUser)
                                      .whenComplete(
                                        () => setState(() => isUpdated = true),
                                      );
                                  // ignore: unused_result
                                  ref.refresh(getAllExistingUsersProvider);
                                }
                              },
                              title: "Save",
                              isLoading: authState.isLoading,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
