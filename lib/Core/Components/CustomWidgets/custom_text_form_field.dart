import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.controller,
    this.label,
    this.validator,
    this.onChanged,
    this.isPassword = false,
    this.suffixIcon,
    this.color = Colors.black,
    this.borderRadius = 0,
    this.obscureText = false,
    this.maxLength,
    this.maxLines,
    this.hint,
    this.labelStyle,
    this.fillColor,
    this.hintStyle,
    this.borderSide,
    this.counterColor,
    this.textInputAction,
    this.prefixIcon,
    this.textColor,
    this.keyboardType,
  });

  final String? label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool? isPassword;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? color;
  final Color? fillColor;
  final Color? counterColor;
  final Color? textColor;
  final double? borderRadius;
  final int? maxLength;
  final int? maxLines;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final BorderSide? borderSide;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: color,
      textDirection: TextDirection.ltr,
      maxLength: maxLength,
      maxLines: maxLines,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      style: TextStyle(fontFamily: 'Cairo', color: textColor),
      decoration: InputDecoration(
        counterStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
          color: counterColor,
          fontFamily: 'Cairo',
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        fillColor: fillColor,
        filled: fillColor == null ? false : true,
        hintText: hint,
        labelText: label,
        labelStyle:
            labelStyle ??
            const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
              color: Color(0xffd8d8d8),
              fontFamily: 'Cairo',
            ),
        hintStyle:
            hintStyle ??
            const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 12,
              color: Color(0xffd8d8d8),
              fontFamily: 'Cairo',
            ),
        floatingLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: color,
          fontFamily: 'Cairo',
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: borderSide ?? BorderSide(color: color!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: borderSide ?? BorderSide(color: color!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: borderSide ?? BorderSide(color: color!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius!),
          borderSide: const BorderSide(),
        ),
        suffixIconColor: color,
        prefixIconColor: color,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
      ),
      onChanged: onChanged,
      controller: controller,
      validator: validator,
      obscureText: obscureText!,
    );
  }
}
