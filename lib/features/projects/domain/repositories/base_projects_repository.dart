// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';

import '../../projects.dart';
import '../use_cases/create_projects_use_case.dart';
import '../use_cases/delete_projects_use_case.dart';
import '../use_cases/update_projects_use_case.dart';

abstract class BaseProjectsRepository {
  Future<Either<Failure, ProjectsResponse>> getProjects(params);

  Future<Either<Failure, CreateProjectsResponse>> createProjects(params);

  Future<Either<Failure, DeleteProjectsResponse>> deleteProjects(params);

  Future<Either<Failure, UpdateProjectsResponse>> updateProjects(params);
}
