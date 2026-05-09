import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:portfolio_app/Core/AppData/app_data.dart';

class UsersScreen extends StatelessWidget {
  final String title;
  final Map<String, dynamic> users;

  const UsersScreen({super.key, required this.users, required this.title});

  @override
  Widget build(BuildContext context) {
    final entries = users.entries.toList()
      ..sort(
            (a, b) => int.parse(b.key).compareTo(int.parse(a.key)),
      );
    return CustomScaffold(
      appBar: CustomAppBar(title: title, withBack: true),
      body: ListView.separated(
        itemBuilder: (context, index) => _visitorItem(context, entries[index]),
        separatorBuilder: (context, index) => SizedBox(height: 16.h),
        itemCount: entries.length,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      ),
    );
  }

  Widget _visitorItem(BuildContext context, MapEntry<String, dynamic> e) {
    final date = DateTime.fromMillisecondsSinceEpoch(
      int.parse(e.key),
    ).toLocal();

    final formattedDate = DateFormat('EEE, MMM d • hh:mm:ss a').format(date);

    final visits = e.value;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(border: Border.all(color: AppColors.mainColor)),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.mainColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.visibility_rounded,
              color: AppColors.mainColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 14.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextBody14(formattedDate),
                SizedBox(height: 4.h),
                TextBody14('$visits visits', color: Colors.grey),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: TextBody14('$visits', color: Colors.green),
          ),
        ],
      ),
    );
  }
}
