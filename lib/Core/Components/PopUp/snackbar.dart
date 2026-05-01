import 'package:portfolio_app/Core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

errorGetSnackBar(context, {required String title, String? message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.red,
      content: Responsive.isMobile(context)
          ? Column(
              children: [
                Row(
                  children: [
                    Image.asset(Assets.alertOctagon, height: 48.h, width: 48.w),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextBody14(
                        title,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (message != null) TextBody12(message, color: Colors.white),
              ],
            )
          : Column(
              children: [
                Row(
                  children: [
                    Image.asset(Assets.alertOctagon, height: 24.h, width: 24.w),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextTitle(
                        title,
                        color: Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (message != null) TextBody12(message, color: Colors.white),
              ],
            ),
    ),
  );
}
