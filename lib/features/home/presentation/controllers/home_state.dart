// GENERATED FILE - DO NOT EDIT

part of 'home_cubit.dart';

enum HomeStatus { initial, loading, success, error }

class HomeState extends BaseState {
  final DownloadsEntity? cVDownloadsCount;
  final VisitesEntity? visitesEntity;

  const HomeState({
    super.pageState,
    super.failure,
    super.successIcon,
    super.successMessage,
    this.cVDownloadsCount,
    this.visitesEntity,
  });

  @override
  HomeState copyWith({
    PageState? pageState,
    Failure? failure,
    String? successMessage,
    String? successIcon,
    DownloadsEntity? cVDownloadsCount,
    VisitesEntity? visitesEntity,
  }) {
    return HomeState(
      pageState: pageState ?? this.pageState,
      failure: failure ?? this.failure,
      successMessage: successMessage ?? this.successMessage,
      successIcon: successIcon ?? this.successIcon,
      cVDownloadsCount: cVDownloadsCount ?? this.cVDownloadsCount,
      visitesEntity: visitesEntity ?? this.visitesEntity,
    );
  }

  @override
  List<Object?> get props => [
    pageState,
    failure,
    successMessage,
    successIcon,
    cVDownloadsCount,
    visitesEntity,
  ];
}
