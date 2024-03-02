import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/features/database/providers/get_report_for_activity_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';

class ReportScreen extends ConsumerWidget {
  final String title;

  const ReportScreen({
    super.key,
    required this.title,
  });

  Future<void> exportToCsv(DataTable dataTable) async {
    List<List<dynamic>> dataRows = [];

    // Extract header
    List<dynamic> headerRow = [];
    for (DataColumn column in dataTable.columns) {
      headerRow.add(column.label.toString());
    }
    dataRows.add(headerRow);

    // Extract data rows
    for (DataRow row in dataTable.rows) {
      List<dynamic> dataRow = [];
      for (DataCell cell in row.cells) {
        dataRow.add(cell.child.toString());
      }
      dataRows.add(dataRow);
    }

    // Convert data to CSV format
    String csvData = const ListToCsvConverter().convert(dataRows);

    // Write CSV data to a file
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/table_data.csv';
    File file = File(path);
    await file.writeAsString(csvData);

    print('CSV file exported to $path');
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
                      DataTable(
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
                                    "${reports[index].student.firstName} ${reports[index].student.lastName}"),
                              ),
                              DataCell(
                                Text(reports[index].student.matricNo),
                              ),
                              DataCell(
                                Text(
                                  reports[index].attendanceRecord.toString(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 19.h),
                      const Text("Total Attendance Count: 25"),
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
      floatingActionButton: FloatingActionButton.extended(
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
    );
  }
}
