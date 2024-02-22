import 'package:flutter_application_3/models/activity_model.dart';
import 'package:flutter_application_3/models/attendance_model.dart';
import 'package:flutter_application_3/models/attendance_student.dart';
import 'package:flutter_application_3/models/student_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class LocalDatabaseClient {
  static Future<void> createTable(
    sql.Database database,
    String tablename,
  ) async {
    await database.execute(
      """CREATE TABLE activity(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        type TEXT NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)
    """,
    );
    await database.execute(""" CREATE TABLE attendance(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        activityId INTEGER REFERENCES activity(id),
        createdAt TIMESTAMP  DEFAULT CURRENT_TIMESTAMP NOT NULL
      )
    """);
    await database.execute(""" CREATE TABLE student(
      matricNo TEXT PRIMARY KEY,
      firstName TEXT NOT NULL,
      lastName TEXT NOT NULL,
      department TEXT NOT NULL
    )""");
    await database.execute("""CREATE TABLE attendance_student(
      attendanceId INTEGER REFERENCES attendance(id),
      matricNo TEXT REFERENCES student(matricNo),
      attendanceRecord INTEGER DEFAULT 0,
      createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )""");
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'babcock_attendance',
      version: 1,
      onCreate: (db, version) async {
        await createTable(db, "activity");
      },
    );
  }

  static Future<void> createActivity({required Activity activity}) async {
    final db = await LocalDatabaseClient.db();

    final data = {
      "title": activity.title,
      "imageUrl": activity.imageUrl,
      "type": activity.type
    };
    await db.insert(
      'activity',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Activity>> getActivities({
    required String type,
  }) async {
    final db = await LocalDatabaseClient.db();
    final data = await db.query(
      "activity",
      where: "type = ?",
      whereArgs: [type],
      orderBy: "id",
    );
    final activities = data
        .map(
          (activity) => Activity.fromJson(activity),
        )
        .toList();
    return activities;
  }

  static Future<bool> deleteActivity({required String title}) async {
    try {
      final db = await LocalDatabaseClient.db();
      await db.delete(
        "activity",
        where: "title = ?",
        whereArgs: [title],
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> addStudent(Student student) async {
    try {
      final db = await LocalDatabaseClient.db();
      final studentData = {
        "matricNo": student.matricNo,
        "firstName": student.firstName,
        "lastName": student.lastName,
        "department": student.department
      };
      final alreadyExistingStudent = await db.query(
        "student",
        where: "matricNo = ?",
        whereArgs: [student.matricNo],
      );
      if (alreadyExistingStudent.isEmpty) {
        await db.insert(
          "student",
          studentData,
          conflictAlgorithm: sql.ConflictAlgorithm.replace,
        );
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<void> createAttendanceStudentRow(
      {required Student student, required int attendanceId}) async {
    final db = await LocalDatabaseClient.db();
    final data = {"attendanceId": attendanceId, "matricNo": student.matricNo};
    final row = await db.query(
      "attendance_student",
      where: "matricNo = ? AND attendanceId = ?",
      whereArgs: [student.matricNo, attendanceId],
    );
    if (row.isEmpty) {
      await db.insert(
        "attendance_student",
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
    }
  }

  // attendance
  static Future<void> createAttendanceForActivity({
    required String activityTitle,
    required Student student,
  }) async {
    try {
      final db = await LocalDatabaseClient.db();
      // get the activity so we can get the activity id 😭
      final activityResult = await db.query(
        "activity",
        where: "title = ?",
        whereArgs: [activityTitle],
      );
      final activity = Activity.fromJson(activityResult.first);
      final attendanceData = {
        "activityId": activity.id!,
      };
      final attendanceExist = await db.query(
        "attendance",
        where: "activityId = ?",
        whereArgs: [activity.id],
      );
      if (attendanceExist.isEmpty) {
        final attendanceId = await db.insert(
          "attendance",
          attendanceData,
          conflictAlgorithm: sql.ConflictAlgorithm.replace,
        );
        await addStudent(student);
        await createAttendanceStudentRow(
          student: student,
          attendanceId: attendanceId,
        );
      } else {
        final attendance = Attendance.fromJson(attendanceExist.first);
        final attendanceStudentMap = await db.query(
          "attendance_student",
          where: "attendanceId = ? AND matricNo = ?",
          whereArgs: [attendance.id, student.matricNo],
        );
        final attendanceStudent = AttendanceStudent.fromJson(
          attendanceStudentMap.first,
        );
        var record = attendanceStudent.attendanceRecord;
        final result = await db.update(
          "attendance_student",
          {"attendanceRecord": record += 1},
          where: "attendanceId = ? AND matricNo = ?",
          whereArgs: [attendance.id, student.matricNo],
        );
        print("Id that was changed was $result");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}

// final getStudnetsProvider = FutureProvider<List<Student>>((ref) async {
//   final studnets = await LocalDatabaseClient.getStudents();
//   return studnets;
// });
