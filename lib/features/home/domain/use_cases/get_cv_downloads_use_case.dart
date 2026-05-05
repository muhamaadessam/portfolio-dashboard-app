// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/downloads_model.dart';
import '../../home.dart';
import '../entities/downloads_entity.dart';

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
  final DownloadsEntity downloads;

  const GetCvDownloadsResponse({required this.downloads});

  factory GetCvDownloadsResponse.fromJson(Map<String, dynamic> json) {
    return GetCvDownloadsResponse(
      downloads: DownloadsModel.fromJson(json),
    );
  }

  @override
  List<Object?> get props => [downloads];
}
