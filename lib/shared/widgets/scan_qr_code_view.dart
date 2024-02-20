import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../config/colors/app_colors.dart';
import '../../config/images/app_images.dart';

class ScanQrCodeView extends StatefulWidget {
  const ScanQrCodeView({super.key});

  @override
  State<ScanQrCodeView> createState() => _ScanQrCodeViewState();
}

class _ScanQrCodeViewState extends State<ScanQrCodeView>
    with SingleTickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();

    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _animationController.addListener(() {
      setState(() {});
      if (_animationController.value == 1.0) {
        _animationController.reverse();
      } else if (_animationController.value == 0.0) {
        _animationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 18.h,
                vertical: 24.h,
              ),
              color: Colors.white,
              child: QrImageView(
                padding: EdgeInsets.zero,
                data: '12345667890',
                version: QrVersions.auto,
                size: 200.0,
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
}
