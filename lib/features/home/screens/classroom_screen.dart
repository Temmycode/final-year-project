import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/config/colors/app_colors.dart';
import 'package:flutter_application_3/features/auth/providers/auth_state_notifier_provider.dart';
import 'package:flutter_application_3/features/create_activity_screen.dart';
import 'package:flutter_application_3/features/database/providers/get_activity_provider.dart';
import 'package:flutter_application_3/features/home/screens/activity_selection_screen.dart';
import 'package:flutter_application_3/shared/widgets/activity_cards.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActivityScreen extends ConsumerWidget {
  final String title;
  final String type;

  const ActivityScreen({
    super.key,
    required this.title,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final getActivities = ref.watch(getActivityProvider(type));
    final authState = ref.watch(authStateNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
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
      body: RefreshIndicator.adaptive(
        onRefresh: () {
          return Future.delayed(const Duration(milliseconds: 900), () {
            // ignore: unused_result
            ref.refresh(getActivityProvider(type));
          });
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Column(
              children: [
                getActivities.when(
                  data: (activities) {
                    print(activities);
                    if (activities.isEmpty) {
                      return Container(
                        alignment: Alignment.center,
                        height: MediaQuery.sizeOf(context).height -
                            kToolbarHeight -
                            kBottomNavigationBarHeight,
                        child: Text('No $type yet'),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          return ActivityCards(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ActivitySelectionScreen(
                                    title: activity.title,
                                    type: type,
                                  ),
                                ),
                              );
                            },
                            title: activity.title,
                            image: activity.imageUrl,
                          );
                        },
                      );
                    }
                  },
                  loading: () => Container(
                    alignment: Alignment.center,
                    height: MediaQuery.sizeOf(context).height -
                        kToolbarHeight -
                        kBottomNavigationBarHeight,
                    child: const CircularProgressIndicator.adaptive(),
                  ),
                  error: (error, stk) => Container(
                    alignment: Alignment.center,
                    height: MediaQuery.sizeOf(context).height -
                        kToolbarHeight -
                        kBottomNavigationBarHeight,
                    child: const Text('An error occurred'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.r),
        ),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateActivityScreen(type: type),
          ),
        ),
        child: const Icon(
          Icons.add,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
