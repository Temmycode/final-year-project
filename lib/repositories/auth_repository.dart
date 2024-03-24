import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' show debugPrint;
import 'package:flutter_application_3/cloud/services/cloud_serives.dart';
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
        userModel = UserModel.fromJson(firestoreUser.docs.first.data());
        PreferenceService.userName = userModel.username;
        PreferenceService.email = userModel.email;
        PreferenceService.staffId = userModel.staffId;
        PreferenceService.isloggedIn = true;
        PreferenceService.isAdmin = userModel.isAdmin;

        if (PreferenceService.isFirstLaunch && !userModel.isAdmin) {
          // retrieve information from cloud and store on local storage
          await CloudServices.getDataFromCloudAndBackupToLocalStorage(
            userModel.staffId,
          ).whenComplete(() => PreferenceService.isFirstLaunch = false);
        } else {
          PreferenceService.isFirstLaunch = false;
        }
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        _error = "Invalid Email";
      } else if (e.code == "invalid-credential") {
        _error = "Invalid Credential";
      } else if (e.code == "user-not-found") {
        _error = "User not found";
      } else if (e.code == "wrong-password") {
        _error = "Incorrect Password";
      } else {
        _error = e.code;
      }
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
    required bool isAdmin,
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
        isAdmin: isAdmin,
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
      if (e.code == "email-already-in-use") {
        _error = "This email is already in use";
      } else if (e.code == "invalid-email") {
        _error = "User a valid email address";
      } else if (e.code == "weak-password") {
        _error = "Use a stronger password";
      } else {
        _error = e.code;
      }
      throw FirebaseAuthException(code: e.code);
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
      _error = e.toString();
      return false;
    }
  }

  Future<List<UserModel>> getAllExistingUsers() async {
    try {
      final queryUsers = await firestore
          .collection("users")
          .where("isAdmin", isEqualTo: false)
          .get();

      final users = queryUsers.docs
          .map(
            (user) => UserModel.fromJson(
              user.data(),
            ),
          )
          .toList();
      return users;
    } catch (e) {
      _error = e.toString();
      throw Exception(e.toString());
    }
  }

  Future<void> updateUserDetails(UserModel user) async {
    try {
      final queryRes = await firestore
          .collection("users")
          .where("staffId", isEqualTo: user.staffId)
          .get(); // get the query response of the user
      await firestore
          .collection("users")
          .doc(queryRes.docs.first.reference.id)
          .update(user.toJson()); // update the user with new user values

      // auth.
    } catch (e) {
      _error = e.toString();
      throw Exception();
    }
  }

  Future<void> deleteUserDetails(UserModel user) async {
    try {
      final queryRes = await firestore
          .collection("users")
          .where("staffId", isEqualTo: user.staffId)
          .get(); // get the query response of the user
      await firestore
          .collection("users")
          .doc(queryRes.docs.first.reference.id)
          .delete(); // update the user with new user values

      // auth.
    } catch (e) {
      _error = e.toString();
      throw Exception();
    }
  }

  Future<bool> forgotPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return true;
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == "auth/invalid-email") {
        _error = "Invalid email";
      } else if (e.code == "auth/user-not-found") {
        _error = "User does not exist";
      } else {
        _error = e.code;
      }
      return false;
    } catch (e) {
      print(e);
      _error = e.toString();
      return false;
    }
  }
}
