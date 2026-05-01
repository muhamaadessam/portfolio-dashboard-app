// GENERATED FILE - DO NOT EDIT

import 'package:get_it/get_it.dart';
import 'package:portfolio_app/features/projects/projects.dart';

final di = GetIt.instance;

class ProjectsDI {
  ProjectsDI() {
    call();
  }

  void call() {
    di
      ..registerLazySingleton<BaseProjectsRemoteDataSource>(() => ProjectsRemoteDataSource())
      ..registerLazySingleton<BaseProjectsRepository>(() => ProjectsRepository(di()))
      ..registerLazySingleton(() => GetProjectsUseCase(di()))
      ..registerFactory(() => ProjectsCubit(di(),))
      ;
  }
}
