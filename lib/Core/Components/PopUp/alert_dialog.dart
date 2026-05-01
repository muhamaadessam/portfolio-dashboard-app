import 'package:portfolio_app/Core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showAlertDialog({required BuildContext context, required Widget content}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
      content: content,
    ),
  );
}

void showSuccessDialog(
  BuildContext context, {
  String? message,
  String? icon,
  Widget? nextScreen,
  bool removeAll = false, // 👈 control navigation behavior
}) async {
  showAlertDialog(
    context: context,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(icon ?? Assets.done, width: 40.w, height: 40.h),
        SizedBox(height: 8.h),
        TextBody12(message ?? 'تم إرسال طلبك'),
      ],
    ),
  );

  await Future.delayed(const Duration(seconds: 2));

  if (!context.mounted) return;

  Navigator.of(context, rootNavigator: true).pop();

  if (nextScreen == null) {
    Navigator.pop(context);
    return;
  }

  final route = MaterialPageRoute(builder: (_) => nextScreen);

  if (removeAll) {
    Navigator.of(context).pushAndRemoveUntil(route, (_) => false);
  } else {
    Navigator.of(context).push(route);
  }
}
