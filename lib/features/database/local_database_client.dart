import 'package:flutter_application_3/models/activity_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class LocalDatabaseClient {
  static Future<void> createTable(
    sql.Database database,
    String tablename,
  ) async {
    await database.execute(
      """CREATE TABLE $tablename(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT NOT NULL,
        imageUrl TEXT NOT NULL,
        type TEXT NOT NULL,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)
    """,
    );
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'babcock_attendance',
      version: 1,
      onCreate: (db, version) async {
        await createTable(db, "activities");
        await createTable(db, "attendance");
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
      'activities',
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Activity>> getActivities({
    required String type,
  }) async {
    final db = await LocalDatabaseClient.db();
    final data = await db.query(
      "activities",
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
}
