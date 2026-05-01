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

CUBIT_FILE="$FEATURE_PATH/presentation/controllers/${FEATURE_NAME_LOWER}_cubit.dart"
STATE_FILE="$FEATURE_PATH/presentation/controllers/${FEATURE_NAME_LOWER}_state.dart"

mkdir -p "$FEATURE_PATH/presentation/controllers"

# ---------------------------
# Generate State File
# ---------------------------
cat <<EOL > "$STATE_FILE"
// GENERATED FILE - DO NOT EDIT

part of '${FEATURE_NAME_LOWER}_cubit.dart';

class ${FEATURE_NAME_CAP}State  extends BaseState {


 const ${FEATURE_NAME_CAP}State({
                                    super.pageState,
                                    super.failure,
                                    super.successIcon,
                                    super.successMessage,
                                  });
  @override
  ${FEATURE_NAME_CAP}State copyWith({
                                        PageState? pageState,
                                        Failure? failure,
                                        String? successMessage,
                                        String? successIcon,
                                      }) {
    return ${FEATURE_NAME_CAP}State(pageState: pageState ?? this.pageState,
                                          failure: failure ?? this.failure,
                                          successMessage: successMessage ?? this.successMessage,
                                          successIcon: successIcon ?? this.successIcon,);
  }
}
EOL

echo "✅ State file generated: $STATE_FILE"


# ---------------------------
# Detect UseCases in use_cases folder
# ---------------------------
USECASE_LIST=()
USECASE_PATH="$FEATURE_PATH/domain/use_cases"
if [ -d "$USECASE_PATH" ]; then
  while IFS= read -r file; do
    filename=$(basename "$file" .dart)
    # Convert snake_case to PascalCase
    pascal_case=$(echo "$filename" | awk -F'_' '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) } print}' OFS='')
    USECASE_LIST+=("$pascal_case")
  done < <(find "$USECASE_PATH" -type f -name "*_use_case.dart")
fi

# Prepare constructor injection
CONSTRUCTOR_PARAMS=""
USECASE_FIELDS=""
for uc in "${USECASE_LIST[@]}"; do
  lc_name="$(tr '[:upper:]' '[:lower:]' <<< ${uc:0:1})${uc:1}"
  CONSTRUCTOR_PARAMS="$CONSTRUCTOR_PARAMS this.$lc_name,"
  USECASE_FIELDS="$USECASE_FIELDS  final $uc $lc_name;"
done
CONSTRUCTOR_PARAMS=${CONSTRUCTOR_PARAMS%,} # remove trailing comma

# ---------------------------
# Generate Cubit File
# ---------------------------
cat <<EOL > "$CUBIT_FILE"
// GENERATED FILE - DO NOT EDIT

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../${FEATURE_NAME_LOWER}.dart';
part '${FEATURE_NAME_LOWER}_state.dart';

class ${FEATURE_NAME_CAP}Cubit extends BaseCubit<${FEATURE_NAME_CAP}State> {
$USECASE_FIELDS

  ${FEATURE_NAME_CAP}Cubit($CONSTRUCTOR_PARAMS) : super(${FEATURE_NAME_CAP}State());

  // Example method template
  Future<void> exampleAction() async {
    emit(state.copyWith(pageState: PageState.loading));
    try {
      final result =
               await get${FEATURE_NAME_CAP}UseCase(${FEATURE_NAME_CAP}UseCaseParams(id: 1, name: 'test'));
           result.fold((failure) {
             emit(state.copyWith(pageState: PageState.failure));
           }, (data) {
             emit(state.copyWith(pageState: PageState.success));
           });
    } catch (_) {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }
}
EOL

echo "✅ Cubit file generated with UseCases: $CUBIT_FILE"