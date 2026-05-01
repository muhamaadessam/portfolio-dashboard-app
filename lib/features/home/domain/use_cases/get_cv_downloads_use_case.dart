// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../home.dart';

class GetCvDownloadsUseCase
    extends BaseUseCase<GetCvDownloadsResponse, GetCvDownloadsRequest> {
  final BaseHomeRepository repository;

  GetCvDownloadsUseCase(this.repository);

  @override
  Future<Either<Failure, GetCvDownloadsResponse>> call(
    GetCvDownloadsRequest params,
  ) async {
    return await repository.getCvDownloads(params);
  }
}

class GetCvDownloadsRequest extends Equatable {
  const GetCvDownloadsRequest();

  @override
  List<Object?> get props => [];
}

class GetCvDownloadsResponse extends Equatable {
  final int count;

  const GetCvDownloadsResponse({required this.count});

  factory GetCvDownloadsResponse.fromJson(Map<String, dynamic> json) {
    return GetCvDownloadsResponse(
      count: json['count'],
    );
  }

  @override
  List<Object?> get props => [count];
}
