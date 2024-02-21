import 'package:flutter_application_3/models/activity_model.dart';
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
        activityId INTEGER REFERENCES activity(id)
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    """);
    await database.execute(""" CREATE TABLE student(
      matricNo INTEGER PRIMARY KEY,
      firstName TEXT NOT NULL,
      lastName TEXT NOT NULL,
      department TEXT NOT NULL,
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
}
