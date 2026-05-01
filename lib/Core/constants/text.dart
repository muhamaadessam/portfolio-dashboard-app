import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextTitle extends StatelessWidget {
  const TextTitle(
    this.text, {
    super.key,
    this.textAlign,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.overflow,
  });

  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.bold,
        fontSize: (fontSize ?? 24).spMax,
        color: color,
        fontFamily: 'FiraCode-Regular',
      ),
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow,
    );
  }
}

class TextBody14 extends StatelessWidget {
  const TextBody14(
    this.text, {
    super.key,
    this.textAlign,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.overflow,
  });

  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: (fontSize ?? 18).spMax,
        color: color,
        fontFamily: 'FiraCode-Regular',
      ),
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow,
    );
  }
}

class TextBody12 extends StatelessWidget {
  const TextBody12(
    this.text, {
    super.key,
    this.textAlign,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.overflow,
    this.maxLines,
  });

  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: (fontSize ?? 14).spMax,
        color: color,
        fontFamily: 'FiraCode-Regular',
      ),
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}

class TextDescription extends StatelessWidget {
  const TextDescription(
    this.text, {
    super.key,
    this.textAlign,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.overflow,
  });

  final String text;
  final FontWeight? fontWeight;
  final double? fontSize;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: fontWeight ?? FontWeight.normal,
        fontSize: (fontSize ?? 12).spMax,
        color: color,
        fontFamily: 'FiraCode-Regular',
      ),
      textAlign: textAlign ?? TextAlign.start,
      overflow: overflow,
    );
  }
}
