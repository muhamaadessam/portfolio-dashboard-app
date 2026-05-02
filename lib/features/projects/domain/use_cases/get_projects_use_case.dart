// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../projects.dart';

class GetProjectsUseCase
    extends BaseUseCase<ProjectsResponse, ProjectsRequest> {
  final BaseProjectsRepository repository;

  GetProjectsUseCase(this.repository);

  @override
  Future<Either<Failure, ProjectsResponse>> call(ProjectsRequest params) async {
    return await repository.getProjects(params);
  }
}

class ProjectsRequest extends Equatable {
  const ProjectsRequest();

  toJson() {
    // return {'id': id, 'name': name};
  }

  @override
  List<Object?> get props => [];
}

class ProjectsResponse extends Equatable {
  final List<ProjectsEntity> projects;

  const ProjectsResponse({required this.projects});

  @override
  List<Object?> get props => [projects];
}
