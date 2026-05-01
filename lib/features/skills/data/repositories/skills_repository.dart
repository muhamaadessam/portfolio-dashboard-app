import 'package:dartz/dartz.dart';
import 'package:portfolio_app/features/skills/domain/use_cases/create_skills_use_case.dart';
import 'package:portfolio_app/features/skills/domain/use_cases/delete_skills_use_case.dart';
import 'package:portfolio_app/features/skills/domain/use_cases/update_skills_use_case.dart';

import '../../skills.dart';

class SkillsRepository extends BaseSkillsRepository {
  final BaseSkillsRemoteDataSource baseSkillsRemoteDataSource;

  SkillsRepository(this.baseSkillsRemoteDataSource);

  @override
  Future<Either<Failure, List<SkillsEntity>>> getSkills(params) async {
    return await baseSkillsRemoteDataSource.getSkills(params);
  }

  @override
  Future<Either<Failure, CreateSkillsResponse>> createSkills(params) async {
    return await baseSkillsRemoteDataSource.createSkills(params);
  }

  @override
  Future<Either<Failure, DeleteSkillsResponse>> deleteSkills(params) async {
    return await baseSkillsRemoteDataSource.deleteSkills(params);
  }

  @override
  Future<Either<Failure, UpdateSkillsResponse>> updateSkills(params) async {
    return await baseSkillsRemoteDataSource.updateSkills(params);
  }
}
