import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter_application_3/models/user_model.dart';
import 'package:flutter_application_3/shared/services/shared_preference_service.dart';

class AuthRepository {
  const AuthRepository();
  static final auth = FirebaseAuth.instance;
  static final firestore = FirebaseFirestore.instance;
  static String _error = '';
  static String get error => _error;

  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserModel? userModel;
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firestoreUser = await firestore
          .collection('users')
          .where(
            "email",
            isEqualTo: email,
          )
          .get();
      if (firestoreUser.docs.isNotEmpty) {
        userModel = UserModel.fromJson(firestoreUser);
        PreferenceService.userName = userModel.username;
        PreferenceService.email = userModel.email;
        PreferenceService.staffId = userModel.staffId;
        PreferenceService.isloggedIn = true;
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      _error = e.message!;
      return null;
    } catch (e) {
      debugPrint(e.toString());
      _error = e.toString();
      return null;
    }
  }

  Future<UserModel?> signup({
    required String username,
    required String staffId,
    required String email,
    required String password,
  }) async {
    try {
      // create the user
      final user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // add the user to the database
      final userModel = UserModel(
        email: email,
        username: username,
        staffId: staffId,
      );
      final userWithEmailSnapshot = await firestore
          .collection('users')
          .where(
            "email",
            isEqualTo: email,
          )
          .get(); // check the database if there is any user with that particular email
      if (userWithEmailSnapshot.docs.isEmpty) {
        // if the result is empty
        await firestore // add the user to the database
            .collection('users')
            .doc(user.user!.uid)
            .set(userModel.toJson());

        return userModel;
      } else {
        _error = "The user already exists";
        return null;
      }
    } on FirebaseAuthException catch (e) {
      _error = e.message!;
      return null;
    } catch (e) {
      debugPrint(e.toString());
      _error = e.toString();
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      await auth.signOut();
      PreferenceService.clear();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
