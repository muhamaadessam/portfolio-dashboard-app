#!/bin/bash
set -e
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin

FEATURE_PATH=$1
PACKAGE_NAME=${2:-portfolio_app}

if [ -z "$FEATURE_PATH" ]; then
  echo "❌ Feature path is required"
  exit 1
fi

if [ ! -d "$FEATURE_PATH" ]; then
  echo "❌ Path does not exist"
  exit 1
fi

RAW_NAME=$(basename "$FEATURE_PATH")
FEATURE_NAME=$(echo "$RAW_NAME" | sed 's/\([a-z0-9]\)\([A-Z]\)/\1_\2/g' | tr '[:upper:]' '[:lower:]')
DI_FILE="$FEATURE_PATH/${FEATURE_NAME}_di.dart"

echo "// GENERATED FILE - DO NOT EDIT" > "$DI_FILE"
echo "" >> "$DI_FILE"
echo "import 'package:get_it/get_it.dart';" >> "$DI_FILE"

echo "import 'package:$PACKAGE_NAME/${FEATURE_PATH#lib/}/$FEATURE_NAME.dart';" >> "$DI_FILE"

# Collect files
USECASE_CLASSES=()
CUBIT_CLASSES=()
DATA_SOURCE_CLASSES=()
REPO_CLASSES=()

while IFS= read -r file; do
  filename=$(basename "$file")

  # ignore generated files
  if [[ "$filename" == *_di.dart ]] || [[ "$filename" == *.g.dart ]] || [[ "$filename" == *.freezed.dart ]] || [[ "$filename" == *_state.dart ]] || [[ "$filename" == base_* ]]; then
    continue
  fi

  # Determine type
  if [[ "$filename" == *_use_case.dart ]]; then
    prefix=${filename%_use_case.dart}
    prefix=$(echo "$prefix" | awk -F'_' '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) } print}' OFS='')
    classname="${prefix}UseCase"
    USECASE_CLASSES+=("$classname")
  elif [[ "$filename" == *_data_source.dart ]]; then
    classname=$(basename "$file" .dart)
    classname=$(echo "$classname" | awk -F'_' '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) } print}' OFS='')
    DATA_SOURCE_CLASSES+=("$classname")
  elif [[ "$filename" == *_repository.dart ]]; then
    classname=$(basename "$file" .dart)
    classname=$(echo "$classname" | awk -F'_' '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) } print}' OFS='')
    REPO_CLASSES+=("$classname")
  elif [[ "$filename" == *_cubit.dart ]] || [[ "$filename" == *_bloc.dart ]]; then
    classname=$(basename "$file" .dart)
    classname=$(echo "$classname" | awk -F'_' '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) } print}' OFS='')
    CUBIT_CLASSES+=("$classname")
  fi

done < <(find "$FEATURE_PATH" -type f -name "*.dart")

echo "" >> "$DI_FILE"
echo "final di = GetIt.instance;" >> "$DI_FILE"
echo "" >> "$DI_FILE"

PASCAL_NAME=$(echo "$RAW_NAME" | awk -F'_' '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1' OFS='')
DI_CLASS_NAME="${PASCAL_NAME}DI"
echo "class $DI_CLASS_NAME {" >> "$DI_FILE"
echo "  $DI_CLASS_NAME() {" >> "$DI_FILE"
echo "    call();" >> "$DI_FILE"
echo "  }" >> "$DI_FILE"
echo "" >> "$DI_FILE"
echo "  void call() {" >> "$DI_FILE"
echo "    di" >> "$DI_FILE"

# Register DataSources
for ds in "${DATA_SOURCE_CLASSES[@]}"; do
  base="Base$ds"
  echo "      ..registerLazySingleton<$base>(() => $ds())" >> "$DI_FILE"
done

# Register Repositories
for repo in "${REPO_CLASSES[@]}"; do
  base="Base$repo"
  echo "      ..registerLazySingleton<$base>(() => $repo(di()))" >> "$DI_FILE"
done

# Register UseCases
for uc in "${USECASE_CLASSES[@]}"; do
  echo "      ..registerLazySingleton(() => $uc(di()))" >> "$DI_FILE"
done

# Register Cubits
for cubit in "${CUBIT_CLASSES[@]}"; do
  echo -n "      ..registerFactory(() => $cubit(" >> "$DI_FILE"
    count=${#USECASE_CLASSES[@]}
    for ((i=0; i<count; i++)); do
      if [ $i -eq 0 ]; then
        echo -n "di()," >> "$DI_FILE"
      else
        echo -n "di()," >> "$DI_FILE"
      fi
    done
  echo "))" >> "$DI_FILE"
done

echo "      ;" >> "$DI_FILE"
echo "  }" >> "$DI_FILE"
echo "}" >> "$DI_FILE"
