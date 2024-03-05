import 'package:flutter_application_3/models/user_model.dart';
import 'package:flutter_application_3/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getAllExistingUsersProvider = FutureProvider<List<UserModel>>((_) async {
  const auth = AuthRepository();
  return await auth.getAllExistingUsers();
});
