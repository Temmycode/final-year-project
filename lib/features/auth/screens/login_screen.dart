import 'package:flutter/material.dart';
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

                // the login button
                Padding(
                  padding: EdgeInsets.only(bottom: 86.h, top: 320.h),
                  child: PrimaryButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                    title: "Log In",
                    isLoading: false,
                  ),
                )
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
