// GENERATED FILE - DO NOT EDIT

import 'package:get_it/get_it.dart';
import 'package:portfolio_app/features/fun_facts/fun_facts.dart';

final di = GetIt.instance;

class FunFactsDI {
  FunFactsDI() {
    call();
  }

  void call() {
    di
      ..registerLazySingleton<BaseFunFactsRemoteDataSource>(() => FunFactsRemoteDataSource())
      ..registerLazySingleton<BaseFunFactsRepository>(() => FunFactsRepository(di()))
      ..registerLazySingleton(() => GetFunFactsUseCase(di()))
      ..registerFactory(() => FunFactsCubit(di(),))
      ;
  }
}
