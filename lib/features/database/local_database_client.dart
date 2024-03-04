import 'package:flutter_application_3/models/activity_model.dart';
import 'package:flutter_application_3/models/attendance_model.dart';
import 'package:flutter_application_3/models/attendance_student.dart';
import 'package:flutter_application_3/models/report_model.dart';
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
        createdAt TEXT NOT NULL)
    """,
    );
    await database.execute(""" CREATE TABLE attendance(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        activityId INTEGER REFERENCES activity(id),
        createdAt TEXT NOT NULL
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
      attendanceRecord INTEGER DEFAULT 1,
      createdAt TEXT NOT NULL
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
      "type": activity.type,
      "createdAt": activity.createdAt.toIso8601String(),
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

  static Future<int> createAttendance({required int activityId}) async {
    final db = await LocalDatabaseClient.db();

    final attendanceData = {
      "activityId": activityId,
      "createdAt": DateTime.now().toIso8601String(),
    };
    final attendanceId = await db.insert(
      "attendance",
      attendanceData,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    return attendanceId;
  }

  static Future<void> createAttendanceStudentRow({
    required String studentMatricNo,
    required int attendanceId,
  }) async {
    final db = await LocalDatabaseClient.db();
    final data = {
      "attendanceId": attendanceId,
      "matricNo": studentMatricNo,
      "createdAt": DateTime.now().toIso8601String(),
    };
    final row = await db.query(
      "attendance_student",
      where: "matricNo = ? AND attendanceId = ?",
      whereArgs: [studentMatricNo, attendanceId],
    );
    if (row.isEmpty) {
      await db.insert(
        "attendance_student",
        data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace,
      );
      final result = await db.query(
        "attendance_student",
        where: "matricNo = ? AND attendanceId = ?",
        whereArgs: [studentMatricNo, attendanceId],
      );

      AttendanceStudent.fromJson(result.first);
    } else {
      final attendanceStudent = AttendanceStudent.fromJson(row.first);
      var record = attendanceStudent.attendanceRecord;
      await db.update(
        "attendance_student",
        {"attendanceRecord": record += 1},
        where: "attendanceId = ? AND matricNo = ?",
        whereArgs: [attendanceId, studentMatricNo],
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

      final attendanceExist = await db.query(
        "attendance",
        where: "activityId = ?",
        whereArgs: [activity.id],
      );
      if (attendanceExist.isEmpty) {
        final attendanceId = await createAttendance(activityId: activity.id!);
        await addStudent(student);
        await createAttendanceStudentRow(
          studentMatricNo: student.matricNo,
          attendanceId: attendanceId,
        );
      } else {
        // if the attendance exists then attendance-student already exists
        final attendance = Attendance.fromJson(attendanceExist.first);
        await addStudent(student);
        await createAttendanceStudentRow(
          studentMatricNo: student.matricNo,
          attendanceId: attendance.id,
        ); // creating the first instance for the attendance student if the attendance already exists
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  // this function be like marriage ceremony 😂 😂
  static Future<List<Report>> getReportForActivity({
    required String activityTitle,
  }) async {
    final db = await LocalDatabaseClient.db();
    List<Report> reports = [];

    // get the activities with the title
    final activityResult = await db.query(
      "activity",
      where: "title = ?",
      whereArgs: [activityTitle],
    );
    final Activity activity = Activity.fromJson(activityResult.first);

    //get the attendance for that particular activity
    final attendanceResult = await db.query(
      "attendance",
      where: "activityId = ?",
      whereArgs: [activity.id],
    );
    if (attendanceResult.isEmpty) {
      return [];
    }
    final Attendance attendance = Attendance.fromJson(attendanceResult.first);

    // get all the attendance_students with that attendance id
    final attendanceStudentResult = await db.query(
      "attendance_student",
      where: "attendanceId = ?",
      whereArgs: [attendance.id],
    );
    final List<AttendanceStudent> attendanceStudents = attendanceStudentResult
        .map((value) => AttendanceStudent.fromJson(value))
        .toList();

    // get all the students with the matricNumber from the attendance student
    List<Student> students = [];
    for (var attStud in attendanceStudents) {
      final studentResult = await db.query(
        "student",
        where: "matricNo = ?",
        whereArgs: [attStud.matricNo],
      );
      final student = Student.fromJson(studentResult.first);
      students.add(student);
    }

    // create the list of reports
    for (var attStud in attendanceStudents) {
      final student = students.firstWhere(
        (element) => element.matricNo == attStud.matricNo,
      );
      final report = Report(
        student: student,
        attendanceRecord: attStud.attendanceRecord,
      );
      reports.add(report);
    }
    return reports;
  }
}
