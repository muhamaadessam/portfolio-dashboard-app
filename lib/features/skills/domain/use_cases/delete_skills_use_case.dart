// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../skills.dart';

class DeleteSkillsUseCase
    extends BaseUseCase<DeleteSkillsResponse, DeleteSkillsRequest> {
  final BaseSkillsRepository repository;

  DeleteSkillsUseCase(this.repository);

  @override
  Future<Either<Failure, DeleteSkillsResponse>> call(
    DeleteSkillsRequest params,
  ) async {
    return await repository.deleteSkills(params);
  }
}

class DeleteSkillsRequest extends Equatable {
  final String id;

  const DeleteSkillsRequest({required this.id});

  @override
  List<Object?> get props => [id];
}

class DeleteSkillsResponse extends Equatable {
  const DeleteSkillsResponse();

  @override
  List<Object?> get props => [];
}
