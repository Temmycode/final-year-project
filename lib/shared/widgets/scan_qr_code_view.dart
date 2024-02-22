import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/database/local_database_client.dart';
import 'package:flutter_application_3/features/qr_scan/widgets/scan_successful_view.dart';
import 'package:flutter_application_3/models/student_model.dart';
import 'package:flutter_application_3/shared/widgets/back_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../config/colors/app_colors.dart';
import '../../config/images/app_images.dart';

class ScanQrCodeView extends StatefulWidget {
  final String title;

  const ScanQrCodeView({super.key, required this.title});

  @override
  State<ScanQrCodeView> createState() => _ScanQrCodeViewState();
}

class _ScanQrCodeViewState extends State<ScanQrCodeView>
    with SingleTickerProviderStateMixin {
  bool scan =
      true; // this value is what i use to toggle the scan when a student is scanned
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  List<Student> students =
      []; // i use this to hold the students to be stored in the database
  QRViewController? controller; // value is used to control the qr scanner
  late final Animation<double> _animation; // animation value
  late final AnimationController
      _animationController; // controller to control the container that is moving up and down

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      _animationController,
    );

    _animationController.addListener(() {
      setState(() {});
      if (_animationController.value == 1.0) {
        _animationController.reverse();
      } else if (_animationController.value == 0.0) {
        _animationController.forward();
      }
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        Map<String, dynamic> jsonData = jsonDecode(scanData.code!);

        final student = Student.fromJson(jsonData);
        if (!students.contains(student)) {
          students.add(student);
          scan = false;
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Ink(
          width: double.maxFinite,
          color: Colors.black,
          child: Stack(
            children: [
              Positioned(
                left: 35.w,
                bottom: 62.h,
                child: const CustomBackButton(),
              ),
              Positioned(
                top: 122.h,
                left: 0,
                right: 0,
                child: Center(
                  child: scan == true
                      ? scanner()
                      : ScanSuccessfulView(
                          onTap: () {
                            setState(() {
                              scan = true;
                            });
                          },
                          done: () async {
                            // handle the function for the db
                            for (var student in students) {
                              await LocalDatabaseClient
                                  .createAttendanceForActivity(
                                activityTitle: widget.title,
                                student: student,
                              );
                            }
                            Navigator.pop(context);
                          },
                          student: students.last,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget scanner() => Container(
        alignment: Alignment.center,
        width: 290.w,
        height: 310.h,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: SvgPicture.asset(AppImage.qrRect1),
            ),
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(AppImage.qrRect2),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: SvgPicture.asset(AppImage.qrRect3),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(AppImage.qrRect4),
            ),
            Center(
              child: SizedBox(
                height: 273.h,
                width: 247.w,
                child: QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
              ),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Center(
                  child: SizedBox(
                    height: 295.h,
                    child: Transform.translate(
                      offset: Offset(0, _animation.value * -295),
                      child: SizedBox(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            alignment: Alignment.center,
                            width: 265.w,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: AppColors.green1,
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 0),
                                  blurRadius: 10,
                                  spreadRadius: 5,
                                  color: AppColors.green1.withOpacity(0.2),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
}
