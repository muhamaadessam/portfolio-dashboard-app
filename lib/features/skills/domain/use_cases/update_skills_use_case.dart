// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../skills.dart';

class UpdateSkillsUseCase
    extends BaseUseCase<UpdateSkillsResponse, UpdateSkillsRequest> {
  final BaseSkillsRepository repository;

  UpdateSkillsUseCase(this.repository);

  @override
  Future<Either<Failure, UpdateSkillsResponse>> call(
    UpdateSkillsRequest params,
  ) async {
    return await repository.updateSkills(params);
  }
}

class UpdateSkillsRequest extends Equatable {
  final SkillsModel skill;

  const UpdateSkillsRequest({required this.skill});

  @override
  List<Object?> get props => [skill];
}

class UpdateSkillsResponse extends Equatable {
  const UpdateSkillsResponse();

  @override
  List<Object?> get props => [];
}
