import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/config/images/app_images.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/models/student_model.dart';
import 'package:flutter_application_3/shared/widgets/primary_button.dart';
import 'package:flutter_application_3/shared/widgets/snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class StudentQRcodeActionScreen extends ConsumerStatefulWidget {
  final Student student;

  const StudentQRcodeActionScreen({super.key, required this.student});

  @override
  ConsumerState<StudentQRcodeActionScreen> createState() =>
      _StudentQRcodeActionScreenState();
}

class _StudentQRcodeActionScreenState
    extends ConsumerState<StudentQRcodeActionScreen> {
  Uint8List? _imageFile;
//Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status == PermissionStatus.granted;
  }

  @override
  Widget build(BuildContext context) {
    final userData = {
      "firstName": widget.student.firstName,
      "lastName": widget.student.lastName,
      "matricNo": widget.student.matricNo,
      "department": widget.student.department,
    };
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
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 30.h),
              width: 247.w,
              height: 273.h,
              child: Screenshot(
                controller: screenshotController,
                child: Container(
                  color: Colors.white,
                  child: QrImageView(
                    backgroundColor: Colors.white,
                    data: jsonEncode(userData),
                    version: QrVersions.auto,
                  ),
                ),
              ),
            ),
            SizedBox(height: 36.h),
            Text(
              "Student QR Code Successfully Generated",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22.spMin,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 43.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _actionButton(
                  AppImages.share,
                  "Share",
                  onTap: () async {
                    if (!await requestStoragePermission()) {
                      return; // Handle permission denial gracefully
                    }

                    await screenshotController
                        .capture(delay: const Duration(milliseconds: 10))
                        .then(
                      (image) async {
                        if (image != null) {
                          final directory =
                              await getApplicationDocumentsDirectory();
                          final imagePath = await File(
                                  '${directory.path}/${widget.student.firstName} ${widget.student.lastName}.png')
                              .create();
                          await imagePath.writeAsBytes(image);

                          await Share.shareXFiles([XFile(imagePath.path)]);
                        }
                      },
                    );
                  },
                ),
                Platform.isAndroid
                    ? _actionButton(
                        AppImages.download,
                        "Download",
                        onTap: () async {
                          if (Platform.isAndroid) {
                            if (!await requestStoragePermission()) {
                              openAppSettings();
                              return; // Handle permission denial gracefully
                            }

                            final image = await screenshotController.capture();
                            if (image != null) {
                              final path =
                                  '/storage/emulated/0/Download/${widget.student.firstName} ${widget.student.lastName}.png';

                              await File(path).writeAsBytes(image);

                              // ignore: use_build_context_synchronously
                              displaySnack(
                                context,
                                text:
                                    "Image downloaded to your downloads folder",
                              );
                            } else {
                              // ignore: use_build_context_synchronously
                              displaySnack(context,
                                  text: "An error occurred",
                                  color: AppColors.red1);
                              return;
                            }
                          }
                        },
                      )
                    : Container()
              ],
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 50.h),
              child: PrimaryButton(
                onTap: () => Navigator.popUntil(
                  context,
                  (route) => route.isFirst,
                ),
                title: "Done",
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget qrCode(Map<String, dynamic> userData) {
    return QrImageView(
      data: jsonEncode(userData),
      version: QrVersions.auto,
    );
  }

  Widget _actionButton(String image, String title,
      {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            image,
            height: 41.h,
            width: 41.h,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 22.spMin,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          )
        ],
      ),
    );
  }
}
