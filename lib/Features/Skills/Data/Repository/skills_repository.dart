import 'package:dartz/dartz.dart';
import 'package:portfolio_app/Core/Error/failure.dart';

import '../../Domain/Repository/base_skills_repository.dart';
import '../DataSource/skills_remote_data_source.dart';
import '../DataSource/skills_local_data_source.dart';
import '../Models/skill_model.dart';

class SkillsRepository extends BaseSkillsRepository {
  // final BaseSkillsLocalDataSource baseSkillsLocalDataSource;
  final BaseSkillsRemoteDataSource baseSkillsLocalDataSource;

  SkillsRepository(this.baseSkillsLocalDataSource);

  @override
  Future<Either<Failure, List<SkillModel>>> getSkills() {
    return baseSkillsLocalDataSource.getSkills();
  }
}
