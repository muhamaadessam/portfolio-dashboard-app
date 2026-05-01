// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../fun_facts.dart';

class GetFunFactsUseCase extends BaseUseCase<void, FunFactsUseCaseParams> {
  final BaseFunFactsRepository repository;

  GetFunFactsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(FunFactsUseCaseParams params) async {
    return await repository.getFunFacts(params);
  }
}

class FunFactsUseCaseParams extends Equatable {
  final int id;
  final String name;

  const FunFactsUseCaseParams({
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
