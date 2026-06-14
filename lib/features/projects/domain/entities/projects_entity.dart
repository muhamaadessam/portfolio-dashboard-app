import 'package:equatable/equatable.dart';
import 'link_entity.dart';

class ProjectsEntity extends Equatable {
  final String id;
  final String projectName;
  final String projectDescription;
  final String projectImage;
  final List<String> projectLanguages;
  final List<LinkEntity> links;
  final String? category;
  final String? status;
  final bool? isFeatured;

  ProjectsEntity({
    required this.id,
    required this.projectName,
    required this.projectDescription,
    required this.projectImage,
    required this.projectLanguages,
    required this.links,
    this.category,
    this.status,
    this.isFeatured,
  });

  @override
  List<Object?> get props => [
    id,
    projectName,
    projectDescription,
    projectImage,
    projectLanguages,
    links,
    category,
    status,
    isFeatured,
  ];
}
