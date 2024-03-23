import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/admin/screens/admin_actions_screen.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/features/auth/providers/is_logged_in_provider.dart';
import 'package:flutter_application_3/features/auth/screens/login_screen.dart';
import 'package:flutter_application_3/features/home/screens/home_screen.dart';
import 'package:flutter_application_3/features/onboarding/screens/onboarding_screen.dart';
import 'package:flutter_application_3/shared/services/shared_preference_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/colors/app_colors.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await PreferenceService.init(); // Initialize the preference service

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        390,
        844,
      ), // this packge make it easier to dynamically size widgets on your project like the figma file design sizes
      minTextAdapt: true,
      splitScreenMode: false,
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts
              .interTextTheme(), // made the theme of the application inter using the google fonts packge
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: true,
        ),
        home: Consumer(builder: (context, ref, child) {
          final isLoggedIn = ref.watch(isLoggedInProvider);
          if (isLoggedIn) {
            final currentUser = ref.watch(authStateNotifierProvider).user!;
            if (currentUser.isAdmin) {
              return const AdminActionsScreen();
            } else {
              return const HomeScreen();
            }
          } else if (!isLoggedIn && PreferenceService.isFirstLaunch) {
            return const OnboardingScreen();
          } else {
            return const LoginScreen();
          }
        }),
      ),
    );
  }
}
