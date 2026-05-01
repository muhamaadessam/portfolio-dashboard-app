// GENERATED FILE - DO NOT EDIT

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../skills.dart';

class SkillsModel extends SkillsEntity {
  const SkillsModel({
    required super.title,
    required super.skills,
    required super.id,
  });

  factory SkillsModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final json = doc.data()!;

    return SkillsModel(
      id: doc.id,
      title: json['title'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
    );
  }

  toJson() {
    return {'title': title, 'skills': skills};
  }
}
