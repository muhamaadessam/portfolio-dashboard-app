// GENERATED FILE - DO NOT EDIT

import 'package:get_it/get_it.dart';
import 'package:portfolio_app/features/home/home.dart';

import 'domain/use_cases/get_cv_downloads_use_case.dart';

final di = GetIt.instance;

class HomeDI {
  HomeDI() {
    call();
  }

  void call() {
    di
      ..registerLazySingleton<BaseHomeRemoteDataSource>(() => HomeRemoteDataSource())
      ..registerLazySingleton<BaseHomeRepository>(() => HomeRepository(di()))
      ..registerLazySingleton(() => GetVisitorsUseCase(di()))
      ..registerLazySingleton(() => GetCvDownloadsUseCase(di()))
      ..registerFactory(() => HomeCubit(di(),di()))
      ;
  }
}
