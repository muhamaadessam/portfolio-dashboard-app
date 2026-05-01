// GENERATED FILE - DO NOT EDIT

import 'package:get_it/get_it.dart';
import 'package:portfolio_app/features/skills/skills.dart';

import 'domain/use_cases/create_skills_use_case.dart';
import 'domain/use_cases/delete_skills_use_case.dart';
import 'domain/use_cases/update_skills_use_case.dart';

final di = GetIt.instance;

class SkillsDI {
  SkillsDI() {
    call();
  }

  void call() {
    di
      ..registerLazySingleton<BaseSkillsRemoteDataSource>(
        () => SkillsRemoteDataSource(),
      )
      ..registerLazySingleton<BaseSkillsRepository>(
        () => SkillsRepository(di()),
      )
      ..registerLazySingleton(() => GetSkillsUseCase(di()))
      ..registerLazySingleton(() => DeleteSkillsUseCase(di()))
      ..registerLazySingleton(() => CreateSkillsUseCase(di()))
      ..registerLazySingleton(() => UpdateSkillsUseCase(di()))
      ..registerFactory(() => SkillsCubit(di(), di(), di(), di()));
  }
}
