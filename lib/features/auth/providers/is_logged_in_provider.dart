import 'package:flutter_application_3/shared/services/shared_preference_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final isLoggedInProvider = Provider<bool>((ref) {
  final isLoggedIn = PreferenceService.isloggedIn;
  return isLoggedIn;
});
