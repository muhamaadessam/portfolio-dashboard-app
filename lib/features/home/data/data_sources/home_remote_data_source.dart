import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:portfolio_app/features/home/domain/use_cases/get_cv_downloads_use_case.dart';

import '../../home.dart';

abstract class BaseHomeRemoteDataSource {
  Future<Either<Failure, GetVisitorsResponse>> getHome(
    GetVisitorsRequest params,
  );

  Future<Either<Failure, GetCvDownloadsResponse>> getCvDownloads(
    GetCvDownloadsRequest params,
  );
}

class HomeRemoteDataSource implements BaseHomeRemoteDataSource {
  @override
  Future<Either<Failure, GetVisitorsResponse>> getHome(
    GetVisitorsRequest params,
  ) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('stats')
          .doc('visitors')
          .get();

      if (!doc.exists || doc.data() == null) {
        return const Left(DatabaseFailure('visitors data not found'));
      }

      final response = GetVisitorsResponse.fromJson(doc.data()!);

      return Right(response);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, GetCvDownloadsResponse>> getCvDownloads(
    GetCvDownloadsRequest params,
  ) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('stats')
          .doc('cv_downloads')
          .get();

      if (!doc.exists || doc.data() == null) {
        return const Left(DatabaseFailure('CV downloads data not found'));
      }

      final response = GetCvDownloadsResponse.fromJson(doc.data()!);

      return Right(response);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
