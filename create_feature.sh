#!/bin/bash
set -e

FEATURE_NAME=$1
BASE_PATH="lib/features"
RUN_GENERATE_SCRIPT="./run_generate.sh"

if [ -z "$FEATURE_NAME" ]; then
  echo "❌ Feature name is required"
  echo "👉 Usage: ./create_feature.sh feature_name"
  exit 1
fi

FEATURE_PATH="$BASE_PATH/$FEATURE_NAME"

if [ -d "$FEATURE_PATH" ]; then
  echo "⚠️ Feature already exists: $FEATURE_PATH"
  exit 1
fi

echo "🚀 Creating feature: $FEATURE_NAME"

# ==============================
# Create feature structure
# ==============================
mkdir -p \
  "$FEATURE_PATH/data/data_sources" \
  "$FEATURE_PATH/data/models" \
  "$FEATURE_PATH/data/repositories" \
  "$FEATURE_PATH/domain/entities" \
  "$FEATURE_PATH/domain/repositories" \
  "$FEATURE_PATH/domain/use_cases" \
  "$FEATURE_PATH/presentation/controllers" \
  "$FEATURE_PATH/presentation/screens" \
  "$FEATURE_PATH/presentation/widgets"

echo "✅ Feature structure created"

# ==============================
# Run run_generate.sh
# ==============================
chmod +x scripts/*.sh
./scripts/generate_entity_model.sh "$FEATURE_PATH" "$PACKAGE_NAME"
./scripts/create_use_case.sh "$FEATURE_PATH" "$FEATURE_NAME"
./scripts/create_base_repository.sh "$FEATURE_PATH" "$FEATURE_NAME"
./scripts/create_repository.sh "$FEATURE_PATH" "$FEATURE_NAME"
./scripts/create_remote_datasource.sh "$FEATURE_PATH" "$FEATURE_NAME"
./scripts/generate_cubit.sh "$FEATURE_PATH" "$PACKAGE_NAME"
./scripts/create_feature_screen.sh "$FEATURE_PATH" "$PACKAGE_NAME"
./generate_di.sh "$FEATURE_PATH"
./generate_paths.sh "$FEATURE_PATH"

echo "🎉 Done!"
