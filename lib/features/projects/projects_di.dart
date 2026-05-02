// GENERATED FILE - DO NOT EDIT

import 'package:get_it/get_it.dart';
import 'package:portfolio_app/features/projects/projects.dart';

import 'domain/use_cases/create_projects_use_case.dart';
import 'domain/use_cases/delete_projects_use_case.dart';
import 'domain/use_cases/update_projects_use_case.dart';

final di = GetIt.instance;

class ProjectsDI {
  ProjectsDI() {
    call();
  }

  void call() {
    di
      ..registerLazySingleton<BaseProjectsRemoteDataSource>(
        () => ProjectsRemoteDataSource(),
      )
      ..registerLazySingleton<BaseProjectsRepository>(
        () => ProjectsRepository(di()),
      )
      ..registerLazySingleton(() => GetProjectsUseCase(di()))
      ..registerLazySingleton(() => CreateProjectsUseCase(di()))
      ..registerLazySingleton(() => DeleteProjectsUseCase(di()))
      ..registerLazySingleton(() => UpdateProjectsUseCase(di()))
      ..registerFactory(() => ProjectsCubit(di(), di(), di(), di()));
  }
}
