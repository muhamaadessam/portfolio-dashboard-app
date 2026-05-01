import 'package:dartz/dartz.dart';
import 'package:portfolio_app/features/home/domain/use_cases/get_cv_downloads_use_case.dart';

import '../../home.dart';

class HomeRepository extends BaseHomeRepository {
  final BaseHomeRemoteDataSource baseHomeRemoteDataSource;

  HomeRepository(this.baseHomeRemoteDataSource);

  @override
  Future<Either<Failure, GetVisitorsResponse>> getVisitors(params) async {
    return await baseHomeRemoteDataSource.getHome(params);
  }

  @override
  Future<Either<Failure, GetCvDownloadsResponse>> getCvDownloads(
    GetCvDownloadsRequest params,
  ) async {
    return await baseHomeRemoteDataSource.getCvDownloads(params);
  }
}
