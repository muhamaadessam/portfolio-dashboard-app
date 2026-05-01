// GENERATED FILE - DO NOT EDIT

part of 'fun_facts_cubit.dart';

enum FunFactsStatus { initial, loading, success, error }

class FunFactsState extends BaseState {
  const FunFactsState({
    super.pageState,
    super.failure,
    super.successIcon,
    super.successMessage,
  });

  @override
  FunFactsState copyWith({
    PageState? pageState,
    Failure? failure,
    String? successMessage,
    String? successIcon,
  }) {
    return FunFactsState(
      pageState: pageState ?? this.pageState,
      failure: failure ?? this.failure,
      successMessage: successMessage ?? this.successMessage,
      successIcon: successIcon ?? this.successIcon,
    );
  }
}
