import 'package:flutter/material.dart';

import '../core.dart';

extension ContextExtensions on BuildContext {
  // Get the current theme mode
  ThemeMode get themeMode => Theme.of(this).brightness == Brightness.dark
      ? ThemeMode.dark
      : ThemeMode.light;

  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  // Get the current screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  // Get the current screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  // Get the current theme
  ThemeData get theme => Theme.of(this);

  // Get the text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  // Get the current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  Color get mainColor => AppColors.mainColor;

  Color get homeBackgroundColor => AppColors.homeBackgroundColor(this);

  Color get customBackgroundColor => AppColors.customBackgroundColor(this);

  Color get deepBackgroundColor => AppColors.deepBackgroundColor(this);

  Color get appBarColor => AppColors.appBarColor(this);

  Color get containerBackgroundColor =>
      AppColors.containerBackgroundColor(this);

  Color get orderProductColor => AppColors.orderProductColor;

  Color get textColor => AppColors.textColor;

  Color get reverseTextColor => AppColors.reverseTextColor(this);

  Color get errorColor => AppColors.errorColor;

  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';

  bool get isClient => CacheHelper.get(key: 'userType') == 1;

  bool get isLogged => CacheHelper.get(key: 'logged') ?? false;

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  FocusScopeNode get focusScopeNode => FocusScope.of(this);

  void get pop => Navigator.pop(this);

  void successDialog({
    String? message,
    String? icon,
    bool? removeAll,
    Widget? nextScreen,
  }) {
    showSuccessDialog(
      this,
      message: message,
      icon: icon,
      nextScreen: nextScreen,
      removeAll: removeAll ?? false,
    );
  }

  void errorSnackBar({required String title, String? message}) {
    errorGetSnackBar(
      this,
      message: message,
      title: title,
    );
  }
}
