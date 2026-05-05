// GENERATED FILE - DO NOT EDIT

import 'package:equatable/equatable.dart';

class VisitesEntity extends Equatable {
  final int totalVisits;
  final int totalVisitors;
  final Map<String, dynamic> users;


  const VisitesEntity({
    required this.totalVisits,
    required this.totalVisitors,
    required this.users,
  });

  @override
  List<Object> get props => [totalVisits, totalVisitors, users];
}
