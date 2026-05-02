// GENERATED FILE - DO NOT EDIT
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/use_cases/create_projects_use_case.dart';
import '../../projects.dart';
import '../widgets/project_card.dart';

class ProjectsScreen extends BaseView<ProjectsCubit, ProjectsState> {
  ProjectsScreen({super.key});

  @override
  PreferredSizeWidget? appBar(BuildContext context) =>
      AppBar(title: const Text('Projects Screen'));

  @override
  Widget body(BuildContext context, ProjectsState state) {
    return ProjectScreenBody();
  }
}

class ProjectScreenBody extends StatefulWidget {
  const ProjectScreenBody({super.key});

  @override
  State<ProjectScreenBody> createState() => _ProjectScreenBodyState();
}

class _ProjectScreenBodyState extends State<ProjectScreenBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProjectsCubit, ProjectsState>(
      builder: (context, state) {
        return CustomScaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final imageBytes = await pickImage();
              print('==> imageBytes $imageBytes');
              await Future.delayed(const Duration(seconds: 1));
              if (imageBytes == null) return;
              final url = await uploadImageToCloudinary(imageBytes);
              await Future.delayed(const Duration(seconds: 1));

              context.read<ProjectsCubit>().createProject(
                CreateProjectsRequest(
                  project: ProjectsModel(
                    id: '',
                    projectName: '',
                    projectDescription: url,
                    projectImage: url,
                    projectLanguages: [],
                  ),
                ),
              );
            },
            child: const Icon(Icons.add),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 32,
                runSpacing: 32,
                children: List.generate(
                  state.projects.length,
                  (index) => ProjectCard(project: state.projects[index]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  createProjectDialog(BuildContext context) {
    final skillsCubit = context.read<ProjectsCubit>();

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
                    // CustomTextFormField(controller: titleController),
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
                    pickImage();
                    // skillsCubit.cre(
                    //   CreateSkillsRequest(
                    //     skill: SkillsModel(
                    //       title: titleController.text,
                    //       skills: skillsController.map((e) => e.text).toList(),
                    //       id: '',
                    //     ),
                    //   ),
                    // );
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
