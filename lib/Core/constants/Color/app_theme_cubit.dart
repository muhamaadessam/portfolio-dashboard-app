import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_app/Core/core.dart';

part 'app_theme_state.dart';

// class AppThemeCubit extends Cubit<AppThemeState> {
//   AppThemeCubit() : super(AppThemeInitial());
//
//   static AppThemeCubit get(context) => BlocProvider.of(context);
//
//   bool isDark = false;
//   Color mainColor = const Color(0xff1E294D);
//   Color buttonColor = const Color(0xff1E294D);
//   Color homeBackgroundColor = Colors.white;
//   Color customBackgroundColor = const Color(0xffF2F4F8);
//   Color deepBackgroundColor = const Color(0xfff1f1f1);
//   Color appBarColor = Colors.white;
//   Color containerBackgroundColor = Colors.white;
//   Color orderProductColor = const Color(0xff33a9ff);
//   Color textColor = Colors.black;
//   Color reverseTextColor = Colors.black;
//   Color errorColor = Colors.red;
//
//   changeTheme(bool newThem) async {
//     await CacheHelper.init();
//     isDark = newThem;
//     if (isDark) {

//       mainColor = const Color(0xff1E294D);
//       homeBackgroundColor = const Color(0xff272A2F);
//       customBackgroundColor = const Color(0xff272A2F);
//       deepBackgroundColor = const Color(0xff191D23);
//       appBarColor = const Color(0xff191D23);
//       containerBackgroundColor = const Color(0xff191D23);
//       orderProductColor = const Color(0xff33a9ff);
//       textColor = Colors.black;
//       reverseTextColor = Colors.white;
//     } else {
//       mainColor = const Color(0xff1E294D);
//       homeBackgroundColor = Colors.white;
//       customBackgroundColor = const Color(0xffF2F4F8);
//       deepBackgroundColor = const Color(0xfff1f1f1);
//       appBarColor = Colors.white;
//       containerBackgroundColor = Colors.white;
//       orderProductColor = const Color(0xff33a9ff);
//       textColor = Colors.black;
//       reverseTextColor = Colors.black;
//     }
//     CacheHelper.put(key: 'isDark', value: newThem);
//     emit(ChangeAppThemeState());
//   }
// }
class AppThemeCubit extends Cubit<AppThemeState> {
  AppThemeCubit(bool isDark)
      : super(
          AppThemeState(
            isDark: isDark,
            theme: isDark ? darkMode() : lightMode(),
          ),
        );

  static AppThemeCubit get(BuildContext context) =>
      context.read<AppThemeCubit>();

  Future<void> toggleTheme() async {
    final newIsDark = !state.isDark;
    CacheHelper.put(key: 'isDark', value: newIsDark);

    emit(
      AppThemeState(
        isDark: newIsDark,
        theme: newIsDark ? darkMode() : lightMode(),
      ),
    );
  }
}
