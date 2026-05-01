import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/update_skills_use_case.dart';
import '../../skills.dart';

class SkillCard extends StatefulWidget {
  const SkillCard({super.key, required this.skill});

  final SkillsEntity skill;

  @override
  State<SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<SkillCard> {
  late TextEditingController titleController;
  late List<TextEditingController> skillsController;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.skill.title);
    skillsController = widget.skill.skills
        .map((e) => TextEditingController(text: e))
        .toList();
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
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                TextBody14(widget.skill.title, color: Colors.white),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        updateSkillDialog(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: AppColors.errorColor),
                      onPressed: () {
                        context.read<SkillsCubit>().deleteSkill(
                          widget.skill.id,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: AppColors.secondTextColor,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                widget.skill.skills.length,
                (index) => TextBody12(
                  '* ${widget.skill.skills[index]}',
                  color: AppColors.secondTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  updateSkillDialog(BuildContext context) {
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
                    skillsCubit.updateSkill(
                      UpdateSkillsRequest(
                        skill: SkillsModel(
                          title: titleController.text,
                          skills: skillsController.map((e) => e.text).toList(),
                          id: widget.skill.id,
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
