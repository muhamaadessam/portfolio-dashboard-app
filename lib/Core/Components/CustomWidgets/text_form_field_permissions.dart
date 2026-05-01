import 'package:flutter/material.dart';
import 'package:portfolio_app/Core/core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextFormFieldPermissions extends StatelessWidget {
  const TextFormFieldPermissions({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines = 1,
    this.validatorMessage,
    this.suffixIcon,
    this.keyboardType,
    this.readOnly = false,
    this.onTap,
  });

  final TextEditingController controller;
  final String hintText;
  final int? maxLines;
  final String? validatorMessage;
  final String? suffixIcon;
  final TextInputType? keyboardType;
  final bool readOnly;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        style: TextStyle(
          color: context.reverseTextColor,
          fontSize: 14,
          fontFamily: 'Cairo',
        ),
        validator: (value) {
          if (value!.isEmpty && validatorMessage != null) {
            return validatorMessage;
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.all(12.0),
            child: suffixIcon != null
                ? Image.asset(
                    'assets/png/$suffixIcon.png',
                    width: 14.w,
                    height: 14.h,
                  )
                : null,
          ),
          helperStyle: TextStyle(
            color: context.reverseTextColor,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: context.reverseTextColor,
            fontSize: 14,
            fontFamily: 'Cairo',
          ),
          errorStyle: TextStyle(
            color: context.errorColor,
            fontSize: 12,
            fontFamily: 'Cairo',
          ),
          filled: true,
          fillColor: context.appBarColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
      ),
    );
  }
}
