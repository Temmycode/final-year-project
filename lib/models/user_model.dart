import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String username;
  final String staffId;

  const UserModel({
    required this.email,
    required this.username,
    required this.staffId,
  });

  factory UserModel.fromJson(QuerySnapshot snapshot) {
    final json = snapshot.docs.first;
    return UserModel(
        email: json['email'],
        username: json['username'],
        staffId: json['staffId']);
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "staffId": staffId,
        "createdAt": DateTime.now(),
      };

  @override
  String toString() =>
      "UserModel(email: $email, username: $username, staffId: $staffId)";
}
