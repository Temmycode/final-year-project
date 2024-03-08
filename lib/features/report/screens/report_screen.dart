import 'dart:io';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/features/database/providers/get_report_for_activity_provider.dart';
import 'package:flutter_application_3/shared/widgets/snack_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

class ReportScreen extends ConsumerWidget {
  final String title;

  const ReportScreen({
    super.key,
    required this.title,
  });

  Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status == PermissionStatus.granted;
  }

  Future<void> exportToCsv(
    BuildContext context,
    List<Map<String, dynamic>> data,
  ) async {
    final time = TimeOfDay.now();
    if (Platform.isAndroid) {
      if (!await requestStoragePermission()) {
        return; // Handle permission denial gracefully
      }
      // Extract column names from the first data row or use explicit headers if needed
      final List<String> columnNames =
          data.isNotEmpty ? data.first.keys.toList() : [];

      // Add headers as the first row
      final List<List<dynamic>> csvData = [columnNames];

      // Add data rows
      for (final row in data) {
        csvData.add(row.values.toList());
      }

      // final directory = await getDownloadsDirectory();
      final path =
          '/storage/emulated/0/Download/${title + time.toString()}.csv';

      final csv = const ListToCsvConverter().convert(csvData);

      try {
        await File(path).writeAsString(csv);
        // Show success message or notification
        // ignore: use_build_context_synchronously
        displaySnack(
          context,
          text: 'CSV stored successfully to your downloads folder',
        );
      } catch (e) {
        // Handle errors, e.g., file system issues
        // ignore: use_build_context_synchronously
        displaySnack(context, text: e.toString());
      }
    } else if (Platform.isIOS) {
      if (!await requestStoragePermission()) {
        return; // Handle permission denial gracefully
      }
      try {
        final List<String> columnNames =
            data.isNotEmpty ? data.first.keys.toList() : [];

        // Add headers as the first row
        final List<List<dynamic>> csvData = [columnNames];

        // Add data rows
        for (final row in data) {
          csvData.add(row.values.toList());
        }
        final csv = const ListToCsvConverter().convert(csvData);

        /// share image file
        final directory = await getApplicationDocumentsDirectory();
        final csvPath = await File('${directory.path}/$title.csv').create();
        await csvPath.writeAsString(csv);

        /// Share Plugin
        await Share.shareXFiles([XFile(csvPath.path)]);
      } catch (e) {
        debugPrint(e.toString());
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);
    final reportsProvider = ref.watch(getReportForActivityProvider(title));

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shadowColor: Colors.black.withOpacity(0.25),
        leading: CupertinoButton(
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
            weight: 0.5,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.spMin,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.w),
            child: CircleAvatar(
              child: Text(authState.user!.username.characters.first),
            ),
          )
        ],
      ),
      body: reportsProvider.when(
        data: (reports) {
          if (reports.isEmpty) {
            return const Center(
              child: Text("No Reports Yet"),
            );
          } else {
            final dataTable = DataTable(
              columnSpacing: 20.w,
              showBottomBorder: false,
              border: const TableBorder(
                right: BorderSide(),
                left: BorderSide(),
                verticalInside: BorderSide(),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    "S/N",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(
                    "NAME",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    "MATRIC",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
                DataColumn(
                  label: Text(
                    "COUNT",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
              ],
              rows: List.generate(
                reports.length,
                (index) => DataRow(
                  cells: [
                    DataCell(
                      Text("${index + 1}"),
                    ),
                    DataCell(
                      Text(
                          " ${reports[index].student.lastName} ${reports[index].student.firstName}"),
                    ),
                    DataCell(
                      Text(reports[index].student.matricNo),
                    ),
                    DataCell(
                      Text(
                        "${reports[index].attendanceRecord}",
                      ),
                    ),
                  ],
                ),
              ),
            );
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(
                  top: 20.w,
                  left: 11.w,
                  right: 11.w,
                ),
                child: Container(
                  constraints: BoxConstraints(
                    minHeight:
                        MediaQuery.sizeOf(context).height - kToolbarHeight,
                  ),
                  child: Column(
                    children: [
                      dataTable,
                      SizedBox(height: 19.h),
                      Text("Total Attendance Count: ${reports.length}"),
                      SizedBox(height: 19.h),
                    ],
                  ),
                ),
              ),
            );
          }
        },
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        error: (error, stk) => Center(
          child: Text("An error occurred: $error"),
        ),
      ),
      floatingActionButton: reportsProvider.when(
        data: (reports) {
          return FloatingActionButton.extended(
            extendedPadding: EdgeInsets.symmetric(horizontal: 30.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.r),
            ),
            backgroundColor: AppColors.primary,
            onPressed: () async {
              if (reports.isNotEmpty) {
                print("object");

                // convert to csv
                final List<Map<String, dynamic>> dataSource = List.generate(
                  reports.length,
                  (index) => {
                    "S/N": index + 1,
                    "NAME":
                        "${reports[index].student.firstName} ${reports[index].student.lastName}",
                    "MATRIC": reports[index].student.matricNo,
                    "COUNT": reports[index].attendanceRecord
                  },
                );
                await exportToCsv(context, dataSource);
              }
              // if (reports.isNotEmpty) {
              //   // convert to csv

              //   final List<Map<String, dynamic>> dataSource = List.generate(
              //     reports.length,
              //     (index) => {
              //       "S/N": index + 1,
              //       "NAME":
              //           "${reports[index].student.firstName} ${reports[index].student.lastName}",
              //       "MATRIC": int.parse(reports[index].student.matricNo),
              //       "COUNT": reports[index].attendanceRecord
              //     },
              //   );
              //   await exportToCsv(context, dataSource);
              // }
            },
            label: Text(
              "Export",
              style: TextStyle(
                fontSize: 16.spMin,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          );
        },
        error: (err, stk) => Container(),
        loading: () => FloatingActionButton.extended(
          extendedPadding: EdgeInsets.symmetric(horizontal: 30.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
          ),
          backgroundColor: AppColors.primary,
          onPressed: () {},
          label: Text(
            "Export",
            style: TextStyle(
              fontSize: 16.spMin,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
