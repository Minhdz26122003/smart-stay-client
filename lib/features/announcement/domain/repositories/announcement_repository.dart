// lib/features/announcement/domain/repositories/announcement_repository.dart

import '../entities/announcement.dart';

abstract class AnnouncementRepository {
  Future<List<Announcement>> getAnnouncementsByProperty(String propertyId);
  Future<void> createAnnouncement({
    required String propertyId,
    required String title,
    required String body,
  });
  Future<void> deleteAnnouncement(String id);
}
