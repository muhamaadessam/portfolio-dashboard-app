#!/bin/bash
set -e

FEATURE_PATH=$1  # e.g., lib/features/Profile
PACKAGE_NAME=${2:-portfolio_app}

if [ -z "$FEATURE_PATH" ]; then
  echo "❌ Feature path is required"
  exit 1
fi

RAW_NAME=$(basename "$FEATURE_PATH")
FEATURE_NAME_LOWER=$(echo "$RAW_NAME" | sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\2/g' | tr '[:upper:]' '[:lower:]')
FEATURE_NAME_CAP="$(tr '[:lower:]' '[:upper:]' <<< ${RAW_NAME:0:1})${RAW_NAME:1}"

DATASOURCE_DIR="$FEATURE_PATH/data/data_sources"
DATASOURCE_FILE="$DATASOURCE_DIR/${FEATURE_NAME_LOWER}_remote_data_source.dart"

mkdir -p "$DATASOURCE_DIR"

cat <<EOL > "$DATASOURCE_FILE"
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../$FEATURE_NAME_LOWER.dart';


abstract class Base${FEATURE_NAME_CAP}RemoteDataSource {
  Future<Either<Failure, ${FEATURE_NAME_CAP}Entity>> get${FEATURE_NAME_CAP}(${FEATURE_NAME_CAP}UseCaseParams params);

}

class ${FEATURE_NAME_CAP}RemoteDataSource implements Base${FEATURE_NAME_CAP}RemoteDataSource {
  @override
  Future<Either<Failure, ${FEATURE_NAME_CAP}Entity>> get${FEATURE_NAME_CAP}(${FEATURE_NAME_CAP}UseCaseParams params) async {
    try {
      final response = await DioHelper.getData(
        endPoint: 'users/\${CacheHelper.get(key: "userId")}',
        query: params.toJson(),
      );
      return response.fold((failure) {
        return Left(failure);
      }, (data) {
        return Right(${FEATURE_NAME_CAP}Model.fromJson(data['data']));
      });
    } on DioException catch (e) {
      return Left(ServerFailure(DioHelper.handleError(e)));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
EOL

echo "✅ Remote DataSource file generated: $DATASOURCE_FILE"
