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

REPO_DIR="$FEATURE_PATH/data/repositories"
REPO_FILE="$REPO_DIR/${FEATURE_NAME_LOWER}_repository.dart"

mkdir -p "$REPO_DIR"

cat <<EOL > "$REPO_FILE"
import 'package:dartz/dartz.dart';

import '../../$FEATURE_NAME_LOWER.dart';

class ${FEATURE_NAME_CAP}Repository extends Base${FEATURE_NAME_CAP}Repository {
  final Base${FEATURE_NAME_CAP}RemoteDataSource base${FEATURE_NAME_CAP}RemoteDataSource;

  ${FEATURE_NAME_CAP}Repository(this.base${FEATURE_NAME_CAP}RemoteDataSource);

  @override
  Future<Either<Failure, ${FEATURE_NAME_CAP}Entity>> get${FEATURE_NAME_CAP}(params) async {
    return await base${FEATURE_NAME_CAP}RemoteDataSource.get${FEATURE_NAME_CAP}(params);
  }
}
EOL

echo "✅ Repository file generated: $REPO_FILE"
