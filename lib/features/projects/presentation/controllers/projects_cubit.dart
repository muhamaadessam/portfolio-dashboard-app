// GENERATED FILE - DO NOT EDIT

import '../../projects.dart';
import '../../domain/use_cases/create_projects_use_case.dart';
import '../../domain/use_cases/delete_projects_use_case.dart';
import '../../domain/use_cases/update_projects_use_case.dart';
part 'projects_state.dart';

class ProjectsCubit extends BaseCubit<ProjectsState> {
  final GetProjectsUseCase getProjectsUseCase;

  final CreateProjectsUseCase createProjectsUseCase;
  final DeleteProjectsUseCase deleteProjectsUseCase;
  final UpdateProjectsUseCase updateProjectsUseCase;

  ProjectsCubit(this.getProjectsUseCase, this.createProjectsUseCase, this.deleteProjectsUseCase, this.updateProjectsUseCase) : super(ProjectsState());

  @override
  Future<void> initState() async {
    await getProjects();
    return super.initState();
  }

  Future<void> getProjects() async {
    emit(state.copyWith(pageState: PageState.loading));
    try {
      final result = await getProjectsUseCase(ProjectsRequest());
      result.fold(
        (failure) {
          emit(state.copyWith(pageState: PageState.failure));
        },
        (data) {
          emit(
            state.copyWith(
              pageState: PageState.success,
              projects: data.projects,
            ),
          );
        },
      );
    } catch (_) {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  deleteProject(String id) async {
    emit(state.copyWith(pageState: PageState.loading));
    try {
      final result = await deleteProjectsUseCase(DeleteProjectsRequest(id: id));
      result.fold(
        (failure) {
          emit(state.copyWith(pageState: PageState.failure));
        },
        (data) {
          getProjects();
        },
      );
    } catch (_) {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  createProject(CreateProjectsRequest request) async {
    emit(state.copyWith(pageState: PageState.loading));
    try {
      final result = await createProjectsUseCase(request);
      result.fold(
        (failure) {
          emit(state.copyWith(pageState: PageState.failure));
        },
        (data) {
          getProjects();
        },
      );
    } catch (_) {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  updateProject(UpdateProjectsRequest request) async {
    emit(state.copyWith(pageState: PageState.loading));
    try {
      final result = await updateProjectsUseCase(request);
      result.fold(
        (failure) {
          emit(state.copyWith(pageState: PageState.failure));
        },
        (data) {
          getProjects();
        },
      );
    } catch (_) {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }
}
