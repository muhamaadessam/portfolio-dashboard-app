

#!/bin/bash
set -e
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
FEATURE_PATH=$1
PACKAGE_NAME=${2:-portfolio_app}  # optional default package name

if [ -z "$FEATURE_PATH" ]; then
  echo "❌ Feature path is required"
  echo "👉 Example:"
  echo "   ./generate.sh lib/features/AuthProfile"
  exit 1
fi

if [ ! -d "$FEATURE_PATH" ]; then
  echo "❌ Path does not exist"
  echo "   $FEATURE_PATH"
  exit 1
fi

RAW_NAME=$(basename "$FEATURE_PATH")

# تحويل الاسم لـ snake_case + lowercase
FEATURE_NAME=$(echo "$RAW_NAME" \
  | sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\2/g' \
  | tr '[:upper:]' '[:lower:]')

OUTPUT_FILE="$FEATURE_PATH/$FEATURE_NAME.dart"

echo "// GENERATED FILE - DO NOT EDIT" > "$OUTPUT_FILE"
echo "export 'package:portfolio_app/Core/core.dart';" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
# Add commented full import line at the top
echo "// import 'package:$PACKAGE_NAME/${FEATURE_PATH#lib/}/$FEATURE_NAME.dart';" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# ✅ Special case for lib/Core
if [[ "$FEATURE_PATH" == "lib/Core" ]]; then
  echo "export 'package:$PACKAGE_NAME/res/assets.dart';" >> "$OUTPUT_FILE"
  echo "" >> "$OUTPUT_FILE"
fi

find "$FEATURE_PATH" -name "*.dart" \
  ! -name "$FEATURE_NAME.dart" \
  ! -name "*.g.dart" \
  ! -name "*_state.dart" \
  ! -name "*_di.dart" \
  ! -name "*.freezed.dart" | while read file; do
    RELATIVE_PATH="${file#$FEATURE_PATH/}"
    echo "export '$RELATIVE_PATH';" >> "$OUTPUT_FILE"
done

