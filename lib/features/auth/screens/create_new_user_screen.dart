import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/config/images/app_images.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/features/auth/providers/get_all_existing_users_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../shared/widgets/primary_button.dart';

class CreateNewUserScreen extends ConsumerStatefulWidget {
  const CreateNewUserScreen({super.key});

  @override
  ConsumerState<CreateNewUserScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<CreateNewUserScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _staffIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSignedUp = false;

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
          "Activity Attendance",
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
            child: isSignedUp
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
                            SizedBox(height: 30.h),
                            CustomTextField(
                              controller: _passwordController,
                              hintText: "Password",
                              isPassword: true,
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
                                if (_formKey.currentState!.validate()) {
                                  await ref
                                      .read(authStateNotifierProvider.notifier)
                                      .signup(
                                        context: context,
                                        username: _usernameController.text,
                                        email: _emailController.text,
                                        staffId: _staffIdController.text,
                                        password: _passwordController.text,
                                        isAdmin: false,
                                      )
                                      .whenComplete(
                                    () {
                                      setState(() => isSignedUp = true);
                                      // ignore: unused_result
                                      ref.refresh(getAllExistingUsersProvider);
                                    },
                                  );
                                }
                              },
                              title: "Sign Up",
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
