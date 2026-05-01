import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../domain/use_cases/create_skills_use_case.dart';
import '../../domain/use_cases/delete_skills_use_case.dart';
import '../../domain/use_cases/update_skills_use_case.dart';
import '../../skills.dart';

abstract class BaseSkillsRemoteDataSource {
  Future<Either<Failure, List<SkillsEntity>>> getSkills(
    GetSkillsRequest params,
  );

  Future<Either<Failure, CreateSkillsResponse>> createSkills(
    CreateSkillsRequest params,
  );

  Future<Either<Failure, DeleteSkillsResponse>> deleteSkills(
    DeleteSkillsRequest params,
  );

  Future<Either<Failure, UpdateSkillsResponse>> updateSkills(
    UpdateSkillsRequest params,
  );
}

class SkillsRemoteDataSource implements BaseSkillsRemoteDataSource {
  @override
  Future<Either<Failure, List<SkillsEntity>>> getSkills(
    GetSkillsRequest params,
  ) async {
    try {
      final response = await FirebaseFirestore.instance
          .collection('skills')
          .get();

      final skills = response.docs
          .map((doc) => SkillsModel.fromFirestore(doc))
          .toList();

      return Right(skills);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CreateSkillsResponse>> createSkills(
    CreateSkillsRequest params,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('skills')
          .add(params.skill.toJson());

      return const Right(CreateSkillsResponse(id: ''));
    } catch (e) {
      return Left(
        DatabaseFailure(e.toString()),
      );
    }
  }
  @override
  Future<Either<Failure, DeleteSkillsResponse>> deleteSkills(
    DeleteSkillsRequest params,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('skills')
          .doc(params.id)
          .delete();

      return const Right(DeleteSkillsResponse());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UpdateSkillsResponse>> updateSkills(
    UpdateSkillsRequest params,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('skills')
          .doc(params.skill.id)
          .update(params.skill.toJson());

      return const Right(UpdateSkillsResponse());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
