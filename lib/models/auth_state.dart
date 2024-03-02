import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_application_3/models/user_model.dart';

@immutable
class AuthState {
  final bool isLoading;
  final UserModel? user;

  const AuthState({
    required this.user,
    required this.isLoading,
  });

  const AuthState.unknown()
      : isLoading = false,
        user = null;

  AuthState copyIsLoading({required bool isLoading}) => AuthState(
        user: user,
        isLoading: isLoading,
      );

  @override
  bool operator ==(covariant AuthState other) =>
      (user == other.user && isLoading == other.isLoading);
  @override
  int get hashCode => Object.hashAll([
        isLoading,
        user,
      ]);

  @override
  String toString() => 'AuthState(user: $user, isLoading: $isLoading)';
}
