// GENERATED FILE - DO NOT EDIT
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_app/features/skills/domain/use_cases/create_skills_use_case.dart';

import '../../skills.dart';
import '../widgets/skill_card.dart';

class SkillsScreen extends BaseView<SkillsCubit, SkillsState> {
  SkillsScreen({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) =>
      AppBar(title: const Text('Skills Screen'));

  @override
  Widget body(BuildContext context, SkillsState state) {
    return const SkillsBody();
  }
}

class SkillsBody extends StatefulWidget {
  const SkillsBody({super.key});

  @override
  State<SkillsBody> createState() => _SkillsBodyState();
}

class _SkillsBodyState extends State<SkillsBody> {
  late TextEditingController titleController;
  late List<TextEditingController> skillsController;

  @override
  void initState() {
    titleController = TextEditingController();
    skillsController = [TextEditingController()];
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    skillsController.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createSkillDialog(context);
        },
        child: Icon(Icons.add, color: AppColors.mainColor),
      ),
      body: BlocBuilder<SkillsCubit, SkillsState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 16,
                runSpacing: 16,
                children: List.generate(
                  state.skills.length,
                  (index) => SkillCard(skill: state.skills[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  createSkillDialog(BuildContext context) {
    final skillsCubit = context.read<SkillsCubit>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: TextTitle('Add Skills'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextFormField(controller: titleController),

                    const SizedBox(height: 16),

                    ...List.generate(
                      skillsController.length,
                      (index) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                controller: skillsController[index],
                              ),
                            ),

                            IconButton(
                              onPressed: () {
                                setStateDialog(() {
                                  skillsController.add(TextEditingController());
                                });
                              },
                              icon: const Icon(Icons.add),
                            ),

                            if (skillsController.length > 1)
                              IconButton(
                                onPressed: () {
                                  setStateDialog(() {
                                    skillsController.removeAt(index);
                                  });
                                },
                                icon: const Icon(Icons.remove),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  onPressed: () {
                    skillsCubit.createSkill(
                      CreateSkillsRequest(
                        skill: SkillsModel(
                          title: titleController.text,
                          skills: skillsController.map((e) => e.text).toList(),
                          id: '',
                        ),
                      ),
                    );
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
