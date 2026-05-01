// GENERATED FILE - DO NOT EDIT

part of 'projects_cubit.dart';

enum ProjectsStatus { initial, loading, success, error }

class ProjectsState  extends BaseState {


 const ProjectsState({
                                    super.pageState,
                                    super.failure,
                                    super.successIcon,
                                    super.successMessage,
                                  });
  @override
  ProjectsState copyWith({
                                        PageState? pageState,
                                        Failure? failure,
                                        String? successMessage,
                                        String? successIcon,
                                      }) {
    return ProjectsState(pageState: pageState ?? this.pageState,
                                          failure: failure ?? this.failure,
                                          successMessage: successMessage ?? this.successMessage,
                                          successIcon: successIcon ?? this.successIcon,);
  }
}
