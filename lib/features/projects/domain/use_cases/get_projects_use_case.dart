// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../projects.dart';

class GetProjectsUseCase extends BaseUseCase<void, ProjectsUseCaseParams> {
  final BaseProjectsRepository repository;

  GetProjectsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ProjectsUseCaseParams params) async {
    return await repository.getProjects(params);
  }
}

class ProjectsUseCaseParams extends Equatable {
  final int id;
  final String name;

  const ProjectsUseCaseParams({
    required this.id,
    required this.name,
  });

    toJson() {
      return {
        'id': id,
        'name': name,
      };
    }

  @override
  List<Object?> get props => [id, name];
}
