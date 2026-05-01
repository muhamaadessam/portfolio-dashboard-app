// GENERATED FILE - DO NOT EDIT

import '../../fun_facts.dart';

part 'fun_facts_state.dart';

class FunFactsCubit extends BaseCubit<FunFactsState> {
  final GetFunFactsUseCase getFunFactsUseCase;

  FunFactsCubit(this.getFunFactsUseCase) : super(FunFactsState());

  // Example method template
  Future<void> exampleAction() async {
    emit(state.copyWith(pageState: PageState.loading));
    try {
      final result = await getFunFactsUseCase(
        FunFactsUseCaseParams(id: 1, name: 'test'),
      );
      result.fold(
        (failure) {
          emit(state.copyWith(pageState: PageState.failure));
        },
        (data) {
          emit(state.copyWith(pageState: PageState.success));
        },
      );
    } catch (_) {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }
}
