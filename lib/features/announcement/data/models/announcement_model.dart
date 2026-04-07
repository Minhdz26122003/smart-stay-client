// lib/features/announcement/data/models/announcement_model.dart

import '../../domain/entities/announcement.dart';

class AnnouncementModel extends Announcement {
  const AnnouncementModel({
    required super.id,
    required super.propertyId,
    required super.title,
    required super.body,
    required super.createdByName,
    required super.createdAt,
    required super.isPinned,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as String,
      propertyId: json['propertyId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      createdByName: json['createdByName'] as String? ?? 'Chủ nhà',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      isPinned: json['isPinned'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'propertyId': propertyId,
        'title': title,
        'body': body,
      };
}
