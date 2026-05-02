import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/projects_entity.dart';

class ProjectsModel extends ProjectsEntity {
  ProjectsModel({
    required super.id,
    required super.projectName,
    required super.projectDescription,
    required super.projectImage,
    required super.projectLanguages,
    super.googlePlayLink,
    super.appStoreLink,
  });

  factory ProjectsModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final json = doc.data()!;

    return ProjectsModel(
      id: doc.id,
      projectName: json['projectName'],
      projectDescription: json['projectDescription'],
      projectImage: json['projectImage'],
      projectLanguages: List<String>.from(json['projectLanguages']),
      googlePlayLink: json['googlePlayLink'],
      appStoreLink: json['appStoreLink'],
    );
  }

  toJson() {
    return {
      'projectName': projectName,
      'projectDescription': projectDescription,
      'projectImage': projectImage,
      'projectLanguages': projectLanguages,
      'googlePlayLink': googlePlayLink,
      'appStoreLink': appStoreLink,
    };
  }
}
