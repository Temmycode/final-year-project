import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/features/auth/providers/get_all_existing_users_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllUserAccountsScreen extends ConsumerWidget {
  const AllUserAccountsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateNotifierProvider);
    final allExsitingUsers = ref.watch(getAllExistingUsersProvider);

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
          "All User Account(s)",
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
      body: allExsitingUsers.when(
        data: (users) {
          if (users.isEmpty) {
            return const Center(
              child: Text("No Users Yet"),
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
                    "STAFF ID",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  numeric: true,
                ),
              ],
              rows: List.generate(
                users.length,
                (index) => DataRow(
                  cells: [
                    DataCell(
                      Text("${index + 1}"),
                    ),
                    DataCell(
                      Text(
                        users[index].username,
                      ),
                    ),
                    DataCell(
                      Text(users[index].staffId),
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
    );
  }
}
