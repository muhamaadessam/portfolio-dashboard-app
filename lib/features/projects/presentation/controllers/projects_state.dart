// GENERATED FILE - DO NOT EDIT

part of 'projects_cubit.dart';

class ProjectsState extends BaseState {
  final List<ProjectsEntity> projects;

  const ProjectsState({
    super.pageState,
    super.failure,
    super.successIcon,
    super.successMessage,
    this.projects = const [],
  });

  @override
  ProjectsState copyWith({
    PageState? pageState,
    Failure? failure,
    String? successMessage,
    String? successIcon,
    List<ProjectsEntity>? projects,
  }) {
    return ProjectsState(
      pageState: pageState ?? this.pageState,
      failure: failure ?? this.failure,
      successMessage: successMessage ?? this.successMessage,
      successIcon: successIcon ?? this.successIcon,
      projects: projects ?? this.projects,
    );
  }

  @override
  List<Object?> get props => [
    pageState,
    failure,
    successMessage,
    successIcon,
    projects,
  ];
}
