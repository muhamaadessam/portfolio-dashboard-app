// GENERATED FILE - DO NOT EDIT

import 'package:portfolio_app/features/home/domain/entities/downloads_entity.dart';

class DownloadsModel extends DownloadsEntity {
  const DownloadsModel({
    required super.users,
    required super.totalDownloads,
    required super.totalDownloaders,
  });

  factory DownloadsModel.fromJson(Map<String, dynamic> json) => DownloadsModel(
    totalDownloads: json['total_downloads'] ?? 0,
    totalDownloaders: json['total_downloaders'] ?? 0,
    users: json['users'] ?? {},
  );
}
