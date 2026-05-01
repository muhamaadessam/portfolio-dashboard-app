// GENERATED FILE - DO NOT EDIT

part of 'skills_cubit.dart';

class SkillsState extends BaseState {
  final List<SkillsEntity> skills;
  const SkillsState({
    super.pageState,
    super.failure,
    super.successIcon,
    super.successMessage,
    this.skills = const [],
  });

  @override
  SkillsState copyWith({
    PageState? pageState,
    Failure? failure,
    String? successMessage,
    String? successIcon,
    List<SkillsEntity>? skills,
  }) {
    return SkillsState(
      pageState: pageState ?? this.pageState,
      failure: failure ?? this.failure,
      successMessage: successMessage ?? this.successMessage,
      successIcon: successIcon ?? this.successIcon,
      skills: skills ?? this.skills,
    );
  }
}
