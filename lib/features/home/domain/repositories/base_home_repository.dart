// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:portfolio_app/features/home/domain/use_cases/get_cv_downloads_use_case.dart';

import '../../home.dart';

abstract class BaseHomeRepository {
  Future<Either<Failure, GetVisitorsResponse>> getVisitors(params);

  Future<Either<Failure, GetCvDownloadsResponse>> getCvDownloads(
    GetCvDownloadsRequest params,
  );
}
