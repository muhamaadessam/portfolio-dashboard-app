// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../projects.dart';

class DeleteProjectsUseCase
    extends BaseUseCase<DeleteProjectsResponse, DeleteProjectsRequest> {
  final BaseProjectsRepository repository;

  DeleteProjectsUseCase(this.repository);

  @override
  Future<Either<Failure, DeleteProjectsResponse>> call(
    DeleteProjectsRequest params,
  ) async {
    return await repository.deleteProjects(params);
  }
}

class DeleteProjectsRequest extends Equatable {
  final String id;

  const DeleteProjectsRequest({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteProjectsResponse extends Equatable {
  const DeleteProjectsResponse();

  @override
  List<Object?> get props => [];
}
