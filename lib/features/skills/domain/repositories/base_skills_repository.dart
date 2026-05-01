// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';

import '../../skills.dart';
import '../use_cases/create_skills_use_case.dart';
import '../use_cases/delete_skills_use_case.dart';
import '../use_cases/update_skills_use_case.dart';

abstract class BaseSkillsRepository {
  Future<Either<Failure, List<SkillsEntity>>> getSkills(params);

  Future<Either<Failure, CreateSkillsResponse>> createSkills(params);

  Future<Either<Failure, DeleteSkillsResponse>> deleteSkills(params);

  Future<Either<Failure, UpdateSkillsResponse>> updateSkills(params);
}
