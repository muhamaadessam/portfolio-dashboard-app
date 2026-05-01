#!/bin/bash
set -e

FEATURE_PATH=$1
PACKAGE_NAME=${2:-portfolio_app}

if [ -z "$FEATURE_PATH" ]; then
  echo "❌ Feature path is required"
  exit 1
fi

RAW_NAME=$(basename "$FEATURE_PATH")
FEATURE_NAME_LOWER=$(echo "$RAW_NAME" | sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\2/g' | tr '[:upper:]' '[:lower:]')
FEATURE_NAME_CAP="$(tr '[:lower:]' '[:upper:]' <<< ${RAW_NAME:0:1})${RAW_NAME:1}"

DATA_PATH="$FEATURE_PATH/data"
DOMAIN_PATH="$FEATURE_PATH/domain"

mkdir -p "$DATA_PATH"
mkdir -p "$DOMAIN_PATH"

ENTITY_FILE="$DOMAIN_PATH/entities/${FEATURE_NAME_LOWER}_entity.dart"
MODEL_FILE="$DATA_PATH/models/${FEATURE_NAME_LOWER}_model.dart"

# ---------------------------
# Generate Entity File
# ---------------------------
echo "// GENERATED FILE - DO NOT EDIT" > "$ENTITY_FILE"
echo "" >> "$ENTITY_FILE"
echo "import 'package:equatable/equatable.dart';" >> "$ENTITY_FILE"
echo "" >> "$ENTITY_FILE"
echo "class ${FEATURE_NAME_CAP}Entity extends Equatable {" >> "$ENTITY_FILE"
echo "  final int id;" >> "$ENTITY_FILE"
echo "  final String name;" >> "$ENTITY_FILE"
echo "" >> "$ENTITY_FILE"
echo "  const ${FEATURE_NAME_CAP}Entity({required this.id, required this.name});" >> "$ENTITY_FILE"
echo "" >> "$ENTITY_FILE"
echo "  @override" >> "$ENTITY_FILE"
echo "  List<Object> get props => [id, name];" >> "$ENTITY_FILE"
echo "}" >> "$ENTITY_FILE"

echo "✅ Entity file generated: $ENTITY_FILE"

# ---------------------------
# Generate Model File
# ---------------------------
echo "// GENERATED FILE - DO NOT EDIT" > "$MODEL_FILE"
echo "" >> "$MODEL_FILE"
echo "import '../../$FEATURE_NAME_LOWER.dart';" >> "$MODEL_FILE"
echo "" >> "$MODEL_FILE"
echo "class ${FEATURE_NAME_CAP}Model extends ${FEATURE_NAME_CAP}Entity {" >> "$MODEL_FILE"
echo "  const ${FEATURE_NAME_CAP}Model({required super.id, required super.name});" >> "$MODEL_FILE"
echo "" >> "$MODEL_FILE"
echo "  factory ${FEATURE_NAME_CAP}Model.fromJson(Map<String, dynamic> json) => ${FEATURE_NAME_CAP}Model(" >> "$MODEL_FILE"
echo "        id: json['id']," >> "$MODEL_FILE"
echo "        name: json['name']," >> "$MODEL_FILE"
echo "      );" >> "$MODEL_FILE"
echo "}" >> "$MODEL_FILE"

echo "✅ Model file generated: $MODEL_FILE"
