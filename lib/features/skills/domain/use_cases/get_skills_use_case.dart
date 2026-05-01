// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../skills.dart';

class GetSkillsUseCase
    extends BaseUseCase<List<SkillsEntity>, GetSkillsRequest> {
  final BaseSkillsRepository repository;

  GetSkillsUseCase(this.repository);

  @override
  Future<Either<Failure, List<SkillsEntity>>> call(
    GetSkillsRequest params,
  ) async {
    return await repository.getSkills(params);
  }
}

class GetSkillsRequest extends Equatable {
  const GetSkillsRequest();

  @override
  List<Object?> get props => [];
}
