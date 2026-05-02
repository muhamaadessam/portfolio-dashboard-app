// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../projects.dart';

class CreateProjectsUseCase
    extends BaseUseCase<CreateProjectsResponse, CreateProjectsRequest> {
  final BaseProjectsRepository repository;

  CreateProjectsUseCase(this.repository);

  @override
  Future<Either<Failure, CreateProjectsResponse>> call(
    CreateProjectsRequest params,
  ) async {
    return await repository.createProjects(params);
  }
}

class CreateProjectsRequest extends Equatable {
  final ProjectsModel project;

  const CreateProjectsRequest({required this.project});

  toJson() async {
    return project.toJson();
  }

  @override
  List<Object?> get props => [project];
}

class CreateProjectsResponse extends Equatable {
  final String id;

  const CreateProjectsResponse({required this.id});

  @override
  List<Object?> get props => [id];
}
