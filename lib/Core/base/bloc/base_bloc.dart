import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core.dart';

part 'base_state.dart';

class BaseCubit<T extends BaseState> extends Cubit<T> {
  BaseCubit(super.initialState);
  void emitIfNotClosed(T state) {
    if (!isClosed) {
      emit(state);
    }
  }

  Future<void> initState() async {
    initFeatureConfig();
  }

  void initFeatureConfig() {}
}
