import 'package:dartz/dartz.dart';

import '../../fun_facts.dart';


abstract class BaseFunFactsRemoteDataSource {
  Future<Either<Failure, FunFactsEntity>> getFunFacts(FunFactsUseCaseParams params);

}

class FunFactsRemoteDataSource implements BaseFunFactsRemoteDataSource {
  @override
  Future<Either<Failure, FunFactsEntity>> getFunFacts(FunFactsUseCaseParams params) async {
    try {
      final response = await DioHelper.getData(
        endPoint: 'users/${CacheHelper.get(key: "userId")}',
        query: params.toJson(),
      );
      return response.fold((failure) {
        return Left(failure);
      }, (data) {
        return Right(FunFactsModel.fromJson(data['data']));
      });
    } on DioException catch (e) {
      return Left(ServerFailure(DioHelper.handleError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
