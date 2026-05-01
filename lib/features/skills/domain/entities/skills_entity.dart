// GENERATED FILE - DO NOT EDIT

import 'package:equatable/equatable.dart';

class SkillsEntity extends Equatable {
  final String id;
  final String title;
  final List<String> skills;

  const SkillsEntity({
    required this.title,
    required this.skills,
    required this.id,
  });

  @override
  List<Object?> get props => [title, skills];
}
