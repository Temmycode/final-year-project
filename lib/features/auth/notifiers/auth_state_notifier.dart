import 'package:flutter/material.dart'
    show BuildContext, Navigator, MaterialPageRoute;
import 'package:flutter_application_3/features/admin/screens/admin_actions_screen.dart';
import 'package:flutter_application_3/features/home/screens/home_screen.dart';
import 'package:flutter_application_3/models/auth_state.dart';
import 'package:flutter_application_3/models/user_model.dart';
import 'package:flutter_application_3/repositories/auth_repository.dart';
import 'package:flutter_application_3/shared/services/shared_preference_service.dart';
import 'package:flutter_application_3/shared/widgets/snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  // we create this class so we can have access to the functions of the repository in a provider

  final repository = const AuthRepository();
  AuthStateNotifier() : super(const AuthState.unknown()) {
    if (PreferenceService.isloggedIn) {
      final user = UserModel(
        email: PreferenceService.email,
        username: PreferenceService.userName,
        staffId: PreferenceService.email,
        isAdmin: PreferenceService.isAdmin,
      );
      state = AuthState(isLoading: false, user: user);
    }
  }

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    state = state.copyIsLoading(
      isLoading: true,
    ); // this function simply changes the state of the loading value
    final user = await repository.login(
      email: email,
      password: password,
    ); // calls the login function
    state = AuthState(isLoading: false, user: user); // set the state again
    if (user == null) {
      // call the function for the show snackbar ...

      // ignore: use_build_context_synchronously
      displaySnack(context, text: AuthRepository.error);
    } else if (user.isAdmin) {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const AdminActionsScreen()),
        (route) => false,
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  Future<void> signup({
    required BuildContext context,
    required String username,
    required String email,
    required String password,
    required String staffId,
    required bool isAdmin,
  }) async {
    state = state.copyIsLoading(
      isLoading: true,
    ); // this function simply changes the state of the loading value
    final user = await repository.signup(
      username: username,
      email: email,
      password: password,
      staffId: staffId,
      isAdmin: isAdmin,
    ); // calls the signup function
    state = AuthState(
      isLoading: false,
      user: state.user,
    ); // set the state again // we also make the user null because we don't need the value
    if (user == null) {
      // call the function for the show snackbar ...

      // ignore: use_build_context_synchronously
      displaySnack(context, text: AuthRepository.error);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  Future<void> logout() async {
    state = state.copyIsLoading(isLoading: true);
    await repository.logout();
    state = const AuthState(user: null, isLoading: false);
  }

  Future<void> updateUserDetails(UserModel user) async {
    state = state.copyIsLoading(isLoading: true);
    await repository.updateUserDetails(user);
    state = state.copyIsLoading(isLoading: false);
  }

  Future<void> deleteUserDetails(UserModel user) async {
    state = state.copyIsLoading(isLoading: true);
    await repository.deleteUserDetails(user);
    state = state.copyIsLoading(isLoading: false);
  }
}
