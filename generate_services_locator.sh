#!/bin/bash
set -e
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

PACKAGE_NAME=portfolio_app
OUTPUT_FILE="lib/Core/services_locator.dart"
BASENAME=/usr/bin/basename

echo "// GENERATED FILE - DO NOT EDIT" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "import 'package:flutter/material.dart';" >> "$OUTPUT_FILE"
echo "import 'package:get_it/get_it.dart';" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

DI_CLASSES=()

# ✅ IMPORTANT: no pipe — use process substitution
while IFS= read -r file; do
  RELATIVE_PATH="${file#lib/}"
  echo "import 'package:$PACKAGE_NAME/$RELATIVE_PATH';" >> "$OUTPUT_FILE"

  filename=$($BASENAME "$file" .dart)

  # snake_case_di → PascalCaseDI
  classname=$(echo "$filename" \
    | sed 's/_di$//' \
    | awk -F'_' '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) } print}' OFS='')

  DI_CLASSES+=("${classname}DI")

done < <(find lib -name "*_di.dart" ! -path "lib/Core/*")

echo "" >> "$OUTPUT_FILE"
echo "final di = GetIt.instance;" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "class ServicesLocator {" >> "$OUTPUT_FILE"
echo "  void init() {" >> "$OUTPUT_FILE"
echo "    debugPrint(\"Initializing ServicesLocator...\");" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# ✅ Now this WORKS
for diClass in "${DI_CLASSES[@]}"; do
  echo "    $diClass();" >> "$OUTPUT_FILE"
done

echo "" >> "$OUTPUT_FILE"
echo "    debugPrint(\"ServicesLocator initialized successfully!\");" >> "$OUTPUT_FILE"
echo "  }" >> "$OUTPUT_FILE"
echo "}" >> "$OUTPUT_FILE"

echo "✅ ServicesLocator generated at $OUTPUT_FILE"
