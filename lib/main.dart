import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/attendance_pro.dart';
import 'package:flutter_application_3/shared/services/shared_preference_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await PreferenceService.init(); // Initialize the preference service

  runApp(const ProviderScope(child: AttendancePro()));
}
