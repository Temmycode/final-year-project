import 'package:flutter/foundation.dart' show immutable;

@immutable
class Student {
  final String firstName;
  final String lastName;
  final String matricNo;
  final String department;

  const Student({
    required this.firstName,
    required this.lastName,
    required this.matricNo,
    required this.department,
  });

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "matricNo": matricNo,
        "department": department,
      };

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        firstName: json["firstName"],
        lastName: json["lastName"],
        matricNo: json["matricNo"],
        department: json["department"],
      );
  @override
  String toString() =>
      "Student(firstName: $firstName, lastName: $lastName, matricNo: $matricNo, department: $department)";

  @override
  bool operator ==(covariant Student other) => (other.firstName == firstName &&
      other.lastName == lastName &&
      other.matricNo == matricNo &&
      other.department == department);

  @override
  int get hashCode => Object.hashAll([
        firstName,
        lastName,
        matricNo,
        department,
      ]);
}
