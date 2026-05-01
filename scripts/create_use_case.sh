#!/bin/bash
set -e

FEATURE_DIR=$1
FEATURE_NAME=$2

if [ -z "$FEATURE_DIR" ] || [ -z "$FEATURE_NAME" ]; then
  echo "❌ Usage: $0 <feature_dir> <feature_name>"
  exit 1
fi

FEATURE_NAME_CAP="$(tr '[:lower:]' '[:upper:]' <<< ${FEATURE_NAME:0:1})${FEATURE_NAME:1}"
FEATURE_NAME_LOWER="$(tr '[:upper:]' '[:lower:]' <<< ${FEATURE_NAME_CAP:0:1})${FEATURE_NAME_CAP:1}"

USECASE_DIR="$FEATURE_DIR/domain/use_cases"
mkdir -p "$USECASE_DIR"

USECASE_FILE="$USECASE_DIR/get_${FEATURE_NAME}_use_case.dart"

cat > "$USECASE_FILE" <<EOL
// GENERATED FILE - DO NOT EDIT

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../$FEATURE_NAME.dart';

class Get${FEATURE_NAME_CAP}UseCase extends BaseUseCase<void, ${FEATURE_NAME_CAP}UseCaseParams> {
  final Base${FEATURE_NAME_CAP}Repository repository;

  Get${FEATURE_NAME_CAP}UseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(${FEATURE_NAME_CAP}UseCaseParams params) async {
    return await repository.get${FEATURE_NAME_CAP}(params);
  }
}

class ${FEATURE_NAME_CAP}UseCaseParams extends Equatable {
  final int id;
  final String name;

  const ${FEATURE_NAME_CAP}UseCaseParams({
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
EOL

echo "✅ UseCase created: $USECASE_FILE"
