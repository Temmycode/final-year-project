import 'package:flutter_application_3/features/database/local_database_client.dart';
import 'package:flutter_application_3/models/report_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getReportForActivityProvider =
    FutureProvider.family<List<Report>, String>((ref, String title) async {
  final reports = await LocalDatabaseClient.getReportForActivity(
    activityTitle: title,
  );
  return reports;
});
