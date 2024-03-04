import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/config/images/app_images.dart';
import 'package:flutter_application_3/features/auth/screens/login_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List onboardingItems = [
    [
      AppImage.onboarding1,
      "Take Charge of Your Classroom",
      "Take advantage of our attendance system.",
    ],
    [
      AppImage.onboarding2,
      "Swift and Fast Attendance",
      "Take attendance efficiently.",
    ],
    [
      AppImage.onboarding3,
      "Tons of User Friendly Featured",
      "",
    ],
  ];
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 377.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.r),
                  color: const Color(0xffF4F6FF),
                ),
              ),
            ),
            Positioned(
              bottom: 165.h,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  onDotClicked: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  controller: _pageController,
                  count: onboardingItems.length,
                  effect: SlideEffect(
                    spacing: 19.5.w,
                    dotWidth: 52.w,
                    dotHeight: 8.h,
                    strokeWidth: 1.5,
                    dotColor: const Color(0xffD9D9D9),
                    activeDotColor: AppColors.primary,
                  ),
                ),
              ),
            ),
            PageView.builder(
              controller: _pageController,
              itemCount: onboardingItems.length,
              itemBuilder: (context, index) {
                final image = onboardingItems[index][0];
                final title = onboardingItems[index][1];
                final subtitle = onboardingItems[index][2];
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 25.w),
                        child: Image.asset(image),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(
                        top: 51.h,
                        left: 25.w,
                        right: 25.w,
                      ),
                      height: 377.h,
                      width: double.maxFinite,
                      child: Column(
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 28.spMin,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xff172635),
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            subtitle,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 14.spMin,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xff8E8E8E),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 48.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false),
                      child: Text(
                        "Skip",
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontSize: 18.spMin,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff3F3F3F),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(28.r),
                      onTap: () {
                        switch (_pageController.page) {
                          case 0:
                            _pageController.animateToPage(
                              1,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          case 1:
                            _pageController.animateToPage(
                              2,
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          case 2:
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                                (route) => false);
                        }
                      },
                      child: Container(
                        width: 70.h,
                        height: 68.h,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(28.r),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(0, 18),
                              blurRadius: 31,
                              color: AppColors.primary.withOpacity(0.25),
                            )
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_forward_outlined,
                          size: 32.spMin,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
