// GENERATED FILE - DO NOT EDIT

import '../../projects.dart';

class ProjectsModel extends ProjectsEntity {
  const ProjectsModel({required super.id, required super.name});

  factory ProjectsModel.fromJson(Map<String, dynamic> json) => ProjectsModel(
        id: json['id'],
        name: json['name'],
      );
}
