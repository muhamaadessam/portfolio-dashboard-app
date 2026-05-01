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

SCREEN_DIR="$FEATURE_PATH/presentation/screens"
SCREEN_FILE="$SCREEN_DIR/${FEATURE_NAME_LOWER}_screen.dart"

mkdir -p "$SCREEN_DIR"

# ---------------------------
# Generate Screen File
# ---------------------------
cat <<EOL > "$SCREEN_FILE"
// GENERATED FILE - DO NOT EDIT
import 'package:flutter/material.dart';
import '../../${FEATURE_NAME_LOWER}.dart';


class ${FEATURE_NAME_CAP}Screen extends BaseView<${FEATURE_NAME_CAP}Cubit, ${FEATURE_NAME_CAP}State> {
   ${FEATURE_NAME_CAP}Screen({super.key});
@override
  PreferredSizeWidget? appBar(BuildContext context) => AppBar(
    title: const Text('${FEATURE_NAME_CAP} Screen'),
  );

  @override
  Widget body(BuildContext context, ${FEATURE_NAME_CAP}State state) {
    return Center(
      child: Text('Welcome to ${FEATURE_NAME_CAP} feature!'),
    );
  }
}
EOL

echo "✅ Screen file generated: $SCREEN_FILE"
