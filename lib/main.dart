import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Core/constants/colors.dart';
import 'Core/services_locator.dart';
import 'Features/AboutMe/presentation/controller/cubit.dart';
import 'Features/Projects/Presentation/controller/projects/cubit.dart';
import 'Features/Skills/Presentation/controller/skills/cubit.dart';
import 'firebase_options.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  await mainInitialize();
  runApp(const MyApp());
}

mainInitialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServicesLocator().init();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<SkillsCubit>()..getSkills()),
        BlocProvider(create: (context) => sl<AboutMeCubit>()..getFunFacts()),
        BlocProvider(create: (context) => sl<ProjectsCubit>()..getProjects()),
      ],
      child: MaterialApp.router(
        title: 'Muhammad Essam',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
          scaffoldBackgroundColor: backgroundColor,
          drawerTheme: const DrawerThemeData(backgroundColor: backgroundColor),
          useMaterial3: true,
        ),
      ),
    );
  }
}
