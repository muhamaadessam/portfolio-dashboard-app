import 'package:dartz/dartz.dart';

import '../../fun_facts.dart';

class FunFactsRepository extends BaseFunFactsRepository {
  final BaseFunFactsRemoteDataSource baseFunFactsRemoteDataSource;

  FunFactsRepository(this.baseFunFactsRemoteDataSource);

  @override
  Future<Either<Failure, FunFactsEntity>> getFunFacts(params) async {
    return await baseFunFactsRemoteDataSource.getFunFacts(params);
  }
}
