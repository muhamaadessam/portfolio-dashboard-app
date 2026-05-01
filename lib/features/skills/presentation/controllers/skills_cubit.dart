// GENERATED FILE - DO NOT EDIT

import '../../domain/use_cases/create_skills_use_case.dart';
import '../../domain/use_cases/delete_skills_use_case.dart';
import '../../domain/use_cases/update_skills_use_case.dart';
import '../../skills.dart';

part 'skills_state.dart';

class SkillsCubit extends BaseCubit<SkillsState> {
  final GetSkillsUseCase getSkillsUseCase;
  final CreateSkillsUseCase createSkillsUseCase;
  final DeleteSkillsUseCase deleteSkillsUseCase;
  final UpdateSkillsUseCase updateSkillsUseCase;

  SkillsCubit(
    this.getSkillsUseCase,
    this.createSkillsUseCase,
    this.deleteSkillsUseCase,
    this.updateSkillsUseCase,
  ) : super(SkillsState());

  @override
  Future<void> initState() async {
    await getSkills();
    return super.initState();
  }

  Future<void> getSkills() async {
    emit(state.copyWith(pageState: PageState.loading));
    try {
      final result = await getSkillsUseCase(GetSkillsRequest());
      result.fold(
        (failure) {
          emit(state.copyWith(pageState: PageState.failure));
        },
        (data) {
          emit(state.copyWith(pageState: PageState.success, skills: data));
        },
      );
    } catch (_) {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  deleteSkill(String id) async {
    emit(state.copyWith(pageState: PageState.loading));
    try {
      final result = await deleteSkillsUseCase(DeleteSkillsRequest(id: id));
      result.fold(
        (failure) {
          emit(state.copyWith(pageState: PageState.failure));
        },
        (data) {
          getSkills();
        },
      );
    } catch (_) {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  createSkill(CreateSkillsRequest request) async {
    emit(state.copyWith(pageState: PageState.loading));
    try {
      final result = await createSkillsUseCase(request);
      result.fold(
        (failure) {
          emit(state.copyWith(pageState: PageState.failure));
        },
        (data) {
          getSkills();
        },
      );
    } catch (_) {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }

  updateSkill(UpdateSkillsRequest request) async {
    emit(state.copyWith(pageState: PageState.loading));
    try {
      final result = await updateSkillsUseCase(request);
      result.fold(
        (failure) {
          emit(state.copyWith(pageState: PageState.failure));
        },
        (data) {
          getSkills();
        },
      );
    } catch (_) {
      emit(state.copyWith(pageState: PageState.failure));
    }
  }
}
