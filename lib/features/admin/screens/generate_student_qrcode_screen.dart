import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/features/admin/screens/student_qrcode_action_screen.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/models/student_model.dart';
import 'package:flutter_application_3/shared/widgets/custom_textfield.dart';
import 'package:flutter_application_3/shared/widgets/primary_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GenerateStudentQRcodeScreen extends ConsumerStatefulWidget {
  const GenerateStudentQRcodeScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GenerateStudentQRcodeScreenState();
}

class _GenerateStudentQRcodeScreenState
    extends ConsumerState<GenerateStudentQRcodeScreen> {
  List<String> departments = [
    "Software Engineering",
    "Computer Science",
    "Nursing",
    "Medicine",
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _matricNoController = TextEditingController();
  String department = "Software Engineering";

  @override
  void dispose() {
    super.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _matricNoController.dispose();
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
          "New Student",
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
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 40.h, top: 66.h),
                  child: Text(
                    "Create New Student",
                    textAlign: TextAlign.center,
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
                        controller: _firstNameController,
                        hintText: "First Name",
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _lastNameController,
                        hintText: "Last Name",
                      ),
                      SizedBox(height: 16.h),
                      CustomTextField(
                        controller: _matricNoController,
                        hintText: "Matric No",
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.grey2),
                          borderRadius: BorderRadius.circular(8.r),
                          color: AppColors.grey1,
                        ),
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(8.r),
                          dropdownColor: const Color(0xffF6F6F6),
                          elevation: 0,
                          icon: const Icon(Icons.arrow_downward),
                          underline: Container(),
                          isExpanded: true,
                          value: department,
                          onChanged: (String? newValue) {
                            setState(() {
                              department = newValue!;
                            });
                          },
                          items: departments
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      )
                    ],
                  ),
                ),

                // the login button
                Padding(
                  padding: EdgeInsets.only(bottom: 45.h, top: 200.h),
                  child: Consumer(builder: (context, ref, child) {
                    final authState = ref.watch(authStateNotifierProvider);
                    return PrimaryButton(
                      onTap: () async {
                        final student = Student(
                          firstName: _firstNameController.text,
                          lastName: _lastNameController.text,
                          matricNo: _matricNoController.text,
                          department: department,
                        );
                        if (_firstNameController.text.isNotEmpty ||
                            _lastNameController.text.isNotEmpty ||
                            _matricNoController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  StudentQRcodeActionScreen(student: student),
                            ),
                          );
                        }
                      },
                      title: "Create",
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
