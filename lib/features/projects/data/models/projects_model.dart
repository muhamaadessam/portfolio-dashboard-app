import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/projects_entity.dart';
import 'link_model.dart';

class ProjectsModel extends ProjectsEntity {
  ProjectsModel({
    required super.id,
    required super.projectName,
    required super.projectDescription,
    required super.projectImage,
    required super.projectLanguages,
    required super.links,
    super.category,
    super.status,
    super.isFeatured,
  });

  factory ProjectsModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final json = doc.data()!;

    final List<LinkModel> parsedLinks = [];
    if (json['links'] != null) {
      parsedLinks.addAll(
        List<LinkModel>.from(
          (json['links'] as List).map((x) => LinkModel.fromJson(Map<String, dynamic>.from(x))),
        ),
      );
    } else {
      if (json['googlePlayLink'] != null && (json['googlePlayLink'] as String).isNotEmpty) {
        parsedLinks.add(LinkModel(link: json['googlePlayLink'], title: 'Google Play'));
      }
      if (json['appStoreLink'] != null && (json['appStoreLink'] as String).isNotEmpty) {
        parsedLinks.add(LinkModel(link: json['appStoreLink'], title: 'App Store'));
      }
    }

    return ProjectsModel(
      id: doc.id,
      projectName: json['projectName'] ?? '',
      projectDescription: json['projectDescription'] ?? '',
      projectImage: json['projectImage'] ?? '',
      projectLanguages: List<String>.from(json['projectLanguages'] ?? []),
      links: parsedLinks,
      category: json['category'],
      status: json['status'],
      isFeatured: json['isFeatured'],
    );
  }

  toJson() {
    return {
      'projectName': projectName,
      'projectDescription': projectDescription,
      'projectImage': projectImage,
      'projectLanguages': projectLanguages,
      'links': links.map((x) {
        if (x is LinkModel) {
          return x.toJson();
        }
        return {
          'link': x.link,
          'title': x.title,
        };
      }).toList(),
      'category': category,
      'status': status,
      'isFeatured': isFeatured,
    };
  }
}
