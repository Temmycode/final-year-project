class UserModel {
  final String email;
  final String username;
  final String staffId;
  final bool isAdmin;

  const UserModel({
    required this.email,
    required this.username,
    required this.staffId,
    required this.isAdmin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      username: json['username'],
      staffId: json['staffId'],
      isAdmin: json['isAdmin'],
    );
  }

  Map<String, dynamic> toJson() => {
        "email": email,
        "username": username,
        "staffId": staffId,
        "isAdmin": isAdmin,
        "createdAt": DateTime.now(),
      };

  @override
  String toString() =>
      "UserModel(email: $email, username: $username, isAdmin: $isAdmin, staffId: $staffId)";

  @override
  bool operator ==(covariant UserModel other) =>
      identical(this, other) ||
      (other.email == email &&
          other.username == username &&
          other.isAdmin == isAdmin &&
          other.staffId == staffId &&
          other.runtimeType == runtimeType);

  @override
  int get hashCode => Object.hashAll([
        email,
        username,
        isAdmin,
        staffId,
        runtimeType,
      ]);
}
