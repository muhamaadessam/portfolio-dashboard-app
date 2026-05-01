part of 'base_bloc.dart';

enum PageState {
  init,
  success,
  failure,
  loading,
  shimmerLoading,
  fetchComplete,
  empty,
  successWithDialog,
  errorWithSnackBar,
}

class BaseState extends Equatable {
  final PageState pageState;
  final Failure? failure;
  final String? successMessage;
  final String? successIcon;

  const BaseState({
    this.pageState = PageState.init,
    this.failure,
    this.successMessage,
    this.successIcon,
  });

  BaseState copyWith({
    PageState? pageState,
    Failure? failure,
    String? successMessage,
    String? successIcon,
  }) {
    return BaseState(
      pageState: pageState ?? this.pageState,
      failure: failure ?? this.failure,
      successMessage: successMessage ?? this.successMessage,
      successIcon: successIcon ?? this.successIcon,
    );
  }

  @override
  List<Object?> get props => [
        pageState,
        failure,
        successMessage,
        successIcon,
      ];
}
