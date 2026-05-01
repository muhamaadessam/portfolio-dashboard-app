// GENERATED FILE - DO NOT EDIT

import 'package:portfolio_app/features/home/domain/use_cases/get_cv_downloads_use_case.dart';

import '../../home.dart';

part 'home_state.dart';

class HomeCubit extends BaseCubit<HomeState> {
  final GetVisitorsUseCase getHomeUseCase;
  final GetCvDownloadsUseCase _getCvDownloadsUseCase;

  HomeCubit(this.getHomeUseCase, this._getCvDownloadsUseCase)
    : super(HomeState());


  List<String> get gridItems => [
    'CV Downloads',
    'Visits',
    'Visitors',
  ];

  List<int> get gridValues => [
    state.cVDownloadsCount,
    state.visitesEntity?.totalVisits ?? 0,
    state.visitesEntity?.totalVisitors ?? 0,
  ];
  @override
  Future<void> initState() async {
    await getCvDownloads();
    await getVisites();
    return super.initState();
  }

  Future<void> getVisites() async {
    emit(state.copyWith(pageState: PageState.loading));
    try {
      final result = await getHomeUseCase(GetVisitorsRequest());
      result.fold(
        (failure) {
          emit(state.copyWith(pageState: PageState.failure));
        },
        (data) {
          emit(
            state.copyWith(
              pageState: PageState.success,
              visitesEntity: data.visitesEntity,
            ),
          );
        },
      );
    } catch (_) {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  getCvDownloads() async {
    emit(state.copyWith(pageState: PageState.loading));
    try {
      final result = await _getCvDownloadsUseCase(GetCvDownloadsRequest());
      result.fold(
        (failure) {
          emit(state.copyWith(pageState: PageState.failure));
        },
        (data) {
          emit(
            state.copyWith(
              pageState: PageState.success,
              cVDownloadsCount: data.count,
            ),
          );
        },
      );
    } catch (_) {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }
}
