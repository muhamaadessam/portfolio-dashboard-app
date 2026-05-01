#!/bin/bash
set -e

FEATURE_DIR=$1
FEATURE_NAME=$2

if [ -z "$FEATURE_DIR" ] || [ -z "$FEATURE_NAME" ]; then
  echo "❌ Usage: $0 <feature_dir> <feature_name>"
  exit 1
fi

# Capitalized and lowercase names
FEATURE_NAME_CAP="$(tr '[:lower:]' '[:upper:]' <<< ${FEATURE_NAME:0:1})${FEATURE_NAME:1}"

# Directory for repository
REPO_DIR="$FEATURE_DIR/domain/repositories"
mkdir -p "$REPO_DIR"

REPO_FILE="$REPO_DIR/base_${FEATURE_NAME}_repository.dart"

cat > "$REPO_FILE" <<EOL
// GENERATED FILE - DO NOT EDIT

import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../$FEATURE_NAME.dart';

abstract class Base${FEATURE_NAME_CAP}Repository {
  Future<Either<Failure, ${FEATURE_NAME_CAP}Entity>> get${FEATURE_NAME_CAP}(params);
}
EOL

echo "✅ Base repository created: $REPO_FILE"
