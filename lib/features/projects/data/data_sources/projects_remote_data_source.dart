import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../domain/use_cases/create_projects_use_case.dart';
import '../../domain/use_cases/delete_projects_use_case.dart';
import '../../domain/use_cases/update_projects_use_case.dart';
import '../../projects.dart';

abstract class BaseProjectsRemoteDataSource {
  Future<Either<Failure, ProjectsResponse>> getProjects(ProjectsRequest params);

  Future<Either<Failure, CreateProjectsResponse>> createProjects(
    CreateProjectsRequest params,
  );

  Future<Either<Failure, DeleteProjectsResponse>> deleteProjects(
    DeleteProjectsRequest params,
  );

  Future<Either<Failure, UpdateProjectsResponse>> updateProjects(
    UpdateProjectsRequest params,
  );
}

class ProjectsRemoteDataSource implements BaseProjectsRemoteDataSource {
  @override
  Future<Either<Failure, ProjectsResponse>> getProjects(
    ProjectsRequest params,
  ) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('projects')
          .get();

      final projects = response.docs
          .map((doc) => ProjectsModel.fromFirestore(doc))
          .toList();

      return Right(ProjectsResponse(projects: projects));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CreateProjectsResponse>> createProjects(
    CreateProjectsRequest params,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .add(params.project.toJson());

      return const Right(CreateProjectsResponse(id: ''));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DeleteProjectsResponse>> deleteProjects(
    DeleteProjectsRequest params,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(params.id)
          .delete();

      return const Right(DeleteProjectsResponse());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UpdateProjectsResponse>> updateProjects(
    UpdateProjectsRequest params,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('projects')
          .doc(params.project.id)
          .update(params.project.toJson());

      return const Right(UpdateProjectsResponse());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
