import 'package:dartz/dartz.dart';

import '../../projects.dart';

class ProjectsRepository extends BaseProjectsRepository {
  final BaseProjectsRemoteDataSource baseProjectsRemoteDataSource;

  ProjectsRepository(this.baseProjectsRemoteDataSource);

  @override
  Future<Either<Failure, ProjectsEntity>> getProjects(params) async {
    return await baseProjectsRemoteDataSource.getProjects(params);
  }
}
