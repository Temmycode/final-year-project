import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/custom_textfield.dart';
import '../../../shared/widgets/primary_button.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _staffIdController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                  padding: EdgeInsets.only(bottom: 40.h, top: 66.h),
                  child: Text(
                    "Signup",
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
                        controller: _usernameController,
                        hintText: "Username",
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
                  padding: EdgeInsets.only(bottom: 30.h, top: 200.h),
                  child: Consumer(builder: (context, ref, child) {
                    final authState = ref.watch(authStateNotifierProvider);
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
                              );
                        }
                      },
                      title: "Sign Up",
                      isLoading: authState.isLoading,
                    );
                  }),
                ),

                Container(
                  padding: EdgeInsets.only(top: 10.h),
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Already Have an account? Login"),
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
