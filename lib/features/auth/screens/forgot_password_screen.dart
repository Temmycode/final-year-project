import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/shared/widgets/custom_textfield.dart';
import 'package:flutter_application_3/shared/widgets/primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 23.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 26.h,
                bottom: 22.h,
              ),
              child: Text(
                "Forgot Password",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 30.spMin,
                ),
              ),
            ),
            CustomTextField(
              controller: _emailController,
              hintText: "Enter Your Email",
              isEmail: true,
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: PrimaryButton(
                onTap: () async {
                  await ref
                      .read(authStateNotifierProvider.notifier)
                      .forgotPassword(
                        context,
                        _emailController.text,
                      );
                },
                isLoading: ref.watch(authStateNotifierProvider).isLoading,
                title: "Go",
              ),
            )
          ],
        ),
      ),
    );
  }
}
