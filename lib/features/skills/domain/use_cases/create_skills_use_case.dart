// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../skills.dart';

class CreateSkillsUseCase
    extends BaseUseCase<CreateSkillsResponse, CreateSkillsRequest> {
  final BaseSkillsRepository repository;

  CreateSkillsUseCase(this.repository);

  @override
  Future<Either<Failure, CreateSkillsResponse>> call(
    CreateSkillsRequest params,
  ) async {
    return await repository.createSkills(params);
  }
}

class CreateSkillsRequest extends Equatable {
  final SkillsModel skill;

  const CreateSkillsRequest({required this.skill});

  @override
  List<Object?> get props => [skill];
}

class CreateSkillsResponse extends Equatable {
  final String id;

  const CreateSkillsResponse({required this.id});

  @override
  List<Object?> get props => [id];
}
