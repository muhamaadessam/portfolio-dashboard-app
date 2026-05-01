// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../home.dart';

class GetVisitorsUseCase
    extends BaseUseCase<GetVisitorsResponse, GetVisitorsRequest> {
  final BaseHomeRepository repository;

  GetVisitorsUseCase(this.repository);

  @override
  Future<Either<Failure, GetVisitorsResponse>> call(
    GetVisitorsRequest params,
  ) async {
    return await repository.getVisitors(params);
  }
}

class GetVisitorsRequest extends Equatable {
  const GetVisitorsRequest();

  @override
  List<Object?> get props => [];
}

class GetVisitorsResponse extends Equatable {
  final VisitesModel visitesEntity;

  const GetVisitorsResponse({required this.visitesEntity});

  factory GetVisitorsResponse.fromJson(Map<String, dynamic> json) =>
      GetVisitorsResponse(visitesEntity: VisitesModel.fromJson(json));

  @override
  List<Object?> get props => [visitesEntity];
}
