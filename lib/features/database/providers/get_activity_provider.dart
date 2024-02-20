import 'package:flutter_application_3/features/database/local_database_client.dart';
import 'package:flutter_application_3/models/activity_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getActivityProvider = FutureProvider.family<List<Activity>, String>(
  (ref, String type) async {
    return await LocalDatabaseClient.getActivities(type: type);
  },
);
