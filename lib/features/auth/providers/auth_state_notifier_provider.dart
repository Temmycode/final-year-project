import 'package:flutter_application_3/features/auth/notifiers/auth_state_notifier.dart';
import 'package:flutter_application_3/models/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>(
  (_) => AuthStateNotifier(),
);
