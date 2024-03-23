import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/features/auth/screens/forgot_password_screen.dart';
import 'package:flutter_application_3/models/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../shared/widgets/primary_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final emailController = ref.watch(emailControllerProvider);
    final passwordController = ref.watch(passwordControllerProvider);

    return Scaffold(
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 23.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 84.h, top: 66.h),
                  child: Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 30.spMin,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: emailController,
                        hintText: "Email",
                        isEmail: true,
                      ),
                      SizedBox(height: 46.h),
                      CustomTextField(
                        controller: passwordController,
                        hintText: "Password",
                        isPassword: true,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.h),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      ),
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12.spMin,
                        ),
                      ),
                    ),
                  ),
                ),

                // the login button
                Padding(
                  padding: EdgeInsets.only(
                    bottom: 5.h,
                    top: Platform.isIOS ? 330.h : 360.h,
                  ),
                  child: Consumer(builder: (context, ref, child) {
                    final authState = ref.watch(authStateNotifierProvider);
                    return PrimaryButton(
                      onTap: () async {
                        if (_formKey.currentState!.validate()) {
                          await ref
                              .read(authStateNotifierProvider.notifier)
                              .login(
                                context: context,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                        }
                      },
                      title: "Log In",
                      isLoading: authState.isLoading,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

final emailControllerProvider = Provider.autoDispose<TextEditingController>(
  (_) => TextEditingController(),
);

final passwordControllerProvider = Provider.autoDispose<TextEditingController>(
  (_) => TextEditingController(),
);
