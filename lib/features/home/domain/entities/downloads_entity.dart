// GENERATED FILE - DO NOT EDIT

import 'package:equatable/equatable.dart';

class DownloadsEntity extends Equatable {
  final int totalDownloads;
  final int totalDownloaders;
  final Map<String, dynamic> users;


  const DownloadsEntity({
    required this.totalDownloads,
    required this.totalDownloaders,
    required this.users,
  });

  @override
  List<Object> get props => [totalDownloads, totalDownloaders, users];
}
