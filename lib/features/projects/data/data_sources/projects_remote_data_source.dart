import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../projects.dart';


abstract class BaseProjectsRemoteDataSource {
  Future<Either<Failure, ProjectsEntity>> getProjects(ProjectsUseCaseParams params);

}

class ProjectsRemoteDataSource implements BaseProjectsRemoteDataSource {
  @override
  Future<Either<Failure, ProjectsEntity>> getProjects(ProjectsUseCaseParams params) async {
    try {
      final response = await DioHelper.getData(
        endPoint: 'users/${CacheHelper.get(key: "userId")}',
        query: params.toJson(),
      );
      return response.fold((failure) {
        return Left(failure);
      }, (data) {
        return Right(ProjectsModel.fromJson(data['data']));
      });
    } on DioException catch (e) {
      return Left(ServerFailure(DioHelper.handleError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
