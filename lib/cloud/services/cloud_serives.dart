import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_3/features/database/local_database_client.dart';
import 'package:flutter_application_3/models/activity_model.dart';
import 'package:flutter_application_3/models/attendance_model.dart';
import 'package:flutter_application_3/models/attendance_student.dart';
import 'package:flutter_application_3/models/student_model.dart';

class CloudServices {
  static final firestore = FirebaseFirestore.instance;
  static Future getDataFromCloudAndBackupToLocalStorage(String staffId) async {
    try {
      final List<Student> students = [];
      // retrieve activity
      final cloudActivities = await firestore
          .collection('activities')
          .where("staffId", isEqualTo: staffId)
          .get();
      final activities = cloudActivities.docs
          .map((document) => Activity.fromJson(document.data()))
          .toList();
      // retrieve all the attendances
      final cloudAttendances = await firestore
          .collection('attendance')
          .where('staffId', isEqualTo: staffId)
          .get();

      final attendances = cloudAttendances.docs
          .map((document) => Attendance.fromJson(document.data()))
          .toList();
      // retrieve attendance-students
      final cloudAttendanceStudents = await firestore
          .collection('attendanceStudent')
          .where('staffId', isEqualTo: staffId)
          .get();
      final attendanceStudents = cloudAttendanceStudents.docs
          .map((document) => AttendanceStudent.fromJson(document.data()))
          .toList();
      // retrieve students
      for (var attendanceStudent in attendanceStudents) {
        final cloudStudent = await firestore
            .collection('students')
            .where('matricNo', isEqualTo: attendanceStudent.matricNo)
            .get();
        final student = Student.fromJson(cloudStudent.docs.first.data());
        students.add(student);
      }

      // add them to local storage
      if (activities.isNotEmpty) {
        for (var activity in activities) {
          await LocalDatabaseClient.createActivity(activity: activity);
        }
      }
      if (attendances.isNotEmpty) {
        for (var attendance in attendances) {
          await LocalDatabaseClient.createAttendance(
            activityId: attendance.activityId,
          );
        }
      }
      if (attendanceStudents.isNotEmpty) {
        for (var attendanceStudent in attendanceStudents) {
          await LocalDatabaseClient.createAttendanceStudentRow(
            studentMatricNo: attendanceStudent.matricNo,
            attendanceId: attendanceStudent.attendanceId,
          );
        }
      }
      if (students.isNotEmpty) {
        for (var student in students) {
          await LocalDatabaseClient.addStudent(student);
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future backupToCloud({
    required String staffId,
    required List<Activity> activities,
    required List<Attendance> attendances,
    required List<AttendanceStudent> attendanceStudents,
    required List<Student> students,
  }) async {
    try {
      // store the activities in a collection
      for (var activity in activities) {
        final cloudActivity = await firestore
            .collection('activities')
            .where('id', isEqualTo: activity.id)
            .where('staffId', isEqualTo: staffId)
            .get(); // get the activity

        if (!cloudActivity.docs.first.exists) {
          await firestore.collection('activities').add(activity.toJson());
        }
      }

      // store the attendances in a collection
      for (var attendance in attendances) {
        // we've established that one activity can only have one attendance
        // to save the attendance to cloud, since there are many people who have the same activity or attendance id
        // we just retrieve the data by creating their document id as the activity-id and the staff-id
        final cloudAttendance = await firestore
            .collection('attendance')
            .where('activityId', isEqualTo: attendance.activityId)
            .where('staffId', isEqualTo: staffId)
            .get();

        if (!cloudAttendance.docs.first.exists) {
          // because each user can have many activities but each activity has only one attendance
          // then there should be only one attendance with that activity id
          await firestore.collection('attendance').add(attendance.toJson());
        }
      }

      // store the attendance-students in a collection
      for (var attendanceStudent in attendanceStudents) {
        final cloudAttendanceStudent = await firestore
            .collection('attendanceStudent')
            .where("matricNo", isEqualTo: attendanceStudent.matricNo)
            .where("attendanceId", isEqualTo: attendanceStudent.attendanceId)
            .where("staffId", isEqualTo: staffId)
            .get();

        if (cloudAttendanceStudent.docs.isEmpty) {
          await firestore
              .collection('attendanceStudent')
              .add(attendanceStudent.toJson());
        } else {
          await firestore
              .collection('attendanceStudent')
              .doc(cloudAttendanceStudent.docs.first.reference.id)
              .update(
                attendanceStudent.toJson(),
              ); // update the value if it already exists
        }
      }

      // store the activities in a collection
      for (var student in students) {
        final cloudStudnet = await firestore
            .collection('students')
            .where("matricNo", isEqualTo: student.matricNo)
            .get();

        if (cloudStudnet.docs.isEmpty) {
          await firestore
              .collection('students')
              .doc(student.matricNo.toString())
              .set(student.toJson());
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
