part of 'app_theme_cubit.dart';

@immutable
class AppThemeState {
  final ThemeData theme;
  final bool isDark;

  const AppThemeState({
    required this.theme,
    required this.isDark,
  });
}