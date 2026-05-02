import 'package:dartz/dartz.dart';

import '../../domain/use_cases/create_projects_use_case.dart';
import '../../domain/use_cases/delete_projects_use_case.dart';
import '../../domain/use_cases/update_projects_use_case.dart';
import '../../projects.dart';

class ProjectsRepository extends BaseProjectsRepository {
  final BaseProjectsRemoteDataSource baseProjectsRemoteDataSource;

  ProjectsRepository(this.baseProjectsRemoteDataSource);

  @override
  Future<Either<Failure, ProjectsResponse>> getProjects(params) async {
    return await baseProjectsRemoteDataSource.getProjects(params);
  }


  @override
  Future<Either<Failure, CreateProjectsResponse>> createProjects(params) async {
    return await baseProjectsRemoteDataSource.createProjects(params);
  }

  @override
  Future<Either<Failure, DeleteProjectsResponse>> deleteProjects(params) async {
    return await baseProjectsRemoteDataSource.deleteProjects(params);
  }

  @override
  Future<Either<Failure, UpdateProjectsResponse>> updateProjects(params) async {
    return await baseProjectsRemoteDataSource.updateProjects(params);
  }
}
