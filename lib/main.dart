import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logscope_flutter/logscope_flutter.dart';
import 'package:portfolio_app/Core/core.dart';

import 'firebase_options.dart';
import 'splash_screen.dart';

Future<void> initServices() async {
  debugPrint('starting services ...');
  ServicesLocator().init();
  await CacheHelper.init();
  await DioHelper.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FlutterNativeSplash.remove();
  debugPrint('All services started...');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  Logscope.init(
    enabled: true,
    // master switch (defaults to kDebugMode)
    captureFlutterErrors: true,
    // hook FlutterError + PlatformDispatcher
    showErrorToasts: true,
    // overlay notification on errors
    appName: 'MyApp',
    appVersion: '2.3.1',
    buildNumber: '47',
    deviceModel: 'iPhone 14 Pro',
    // pass from device_info_plus
    osVersion: 'iOS 17.4',
    bufferSize: 1000, // max entries in ring buffer
  );

  runApp(Logscope.wrap(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    CacheHelper.init();
    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      ensureScreenSize: true,
      designSize: const Size(375, 812),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AppThemeCubit(CacheHelper.get(key: 'isDark') ?? false),
          ),
        ],
        child: BlocBuilder<AppThemeCubit, AppThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightMode(),
              darkTheme: darkMode(),
              themeMode: CacheHelper.get(key: 'isDark') ?? false
                  ? ThemeMode.dark
                  : ThemeMode.light,
              home: const SplashScreen(),
            );
          },
        ),
      ),
    );
  }
}
