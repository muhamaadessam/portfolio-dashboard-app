// GENERATED FILE - DO NOT EDIT

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../projects.dart';
part 'projects_state.dart';

class ProjectsCubit extends BaseCubit<ProjectsState> {
  final GetProjectsUseCase getProjectsUseCase;

  ProjectsCubit( this.getProjectsUseCase) : super(ProjectsState());

  // Example method template
  Future<void> exampleAction() async {
    emit(state.copyWith(pageState: PageState.loading));
    try {
      final result =
               await getProjectsUseCase(ProjectsUseCaseParams(id: 1, name: 'test'));
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
