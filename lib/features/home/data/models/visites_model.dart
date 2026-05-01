// GENERATED FILE - DO NOT EDIT

import '../../home.dart';

class VisitesModel extends VisitesEntity {
  const VisitesModel({
    required super.totalVisitors,
    required super.totalVisits,
  });

  factory VisitesModel.fromJson(Map<String, dynamic> json) => VisitesModel(
    totalVisitors: json['total_visitors'] ?? 0,
    totalVisits: json['total_visites'] ?? 0,
  );
}
