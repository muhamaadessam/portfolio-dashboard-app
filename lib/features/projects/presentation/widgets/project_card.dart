import 'package:flutter/material.dart';
import 'package:portfolio_app/Core/AppData/app_data.dart';

import '../../domain/entities/projects_entity.dart';

class ProjectCard extends StatelessWidget {
  const ProjectCard({super.key, required this.project});

  final ProjectsEntity project;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.secondTextColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(project.projectImage, width: double.infinity),
          Container(
            color: AppColors.secondTextColor,
            height: 1,
            width: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 8,
              children: [
                TextTitle(project.projectName, color: Colors.white),
                TextBody14(
                  project.projectDescription,
                  color: AppColors.secondTextColor,
                ),
              ],
            ),
          ),
          if (project.projectLanguages.isNotEmpty)
            Column(
              children: [
                Container(
                  color: AppColors.secondTextColor,
                  height: 1,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 16,
                    children: List.generate(
                      project.projectLanguages.length,
                      (index) => Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            color: AppColors.mainColor,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: TextBody14(project.projectLanguages[index]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(spacing: 16, children: []),
          ),
        ],
      ),
    );
  }
}
