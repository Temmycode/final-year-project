import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/qr_scan/widgets/scan_successful_view.dart';
import 'package:flutter_application_3/shared/widgets/back_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../shared/widgets/scan_qr_code_view.dart';

class QrCodeScanScreen extends ConsumerWidget {
  const QrCodeScanScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Ink(
          height: MediaQuery.sizeOf(context).height - kToolbarHeight,
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
                child: const Center(
                  child: ScanSuccessfulView(),
                  // ScanQrCodeView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
