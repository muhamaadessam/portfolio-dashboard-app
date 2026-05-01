// GENERATED FILE - DO NOT EDIT

import '../../fun_facts.dart';

class FunFactsModel extends FunFactsEntity {
  const FunFactsModel({required super.id, required super.name});

  factory FunFactsModel.fromJson(Map<String, dynamic> json) => FunFactsModel(
        id: json['id'],
        name: json['name'],
      );
}
