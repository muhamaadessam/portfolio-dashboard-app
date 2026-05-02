// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../projects.dart';

class UpdateProjectsUseCase
    extends BaseUseCase<UpdateProjectsResponse, UpdateProjectsRequest> {
  final BaseProjectsRepository repository;

  UpdateProjectsUseCase(this.repository);

  @override
  Future<Either<Failure, UpdateProjectsResponse>> call(
    UpdateProjectsRequest params,
  ) async {
    return await repository.updateProjects(params);
  }
}

class UpdateProjectsRequest extends Equatable {
  final ProjectsModel project;

  const UpdateProjectsRequest({required this.project});

  @override
  List<Object?> get props => [project];
}

class UpdateProjectsResponse extends Equatable {
  const UpdateProjectsResponse();

  @override
  List<Object?> get props => [];
}
