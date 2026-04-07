// lib/features/announcement/data/repositories/announcement_repository_impl.dart

import '../../domain/entities/announcement.dart';
import '../../domain/repositories/announcement_repository.dart';
import '../datasources/announcement_remote_datasource.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementRemoteDataSource _dataSource;

  AnnouncementRepositoryImpl({required AnnouncementRemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  Future<List<Announcement>> getAnnouncementsByProperty(
      String propertyId) async {
    return _dataSource.getAnnouncementsByProperty(propertyId);
  }

  @override
  Future<void> createAnnouncement({
    required String propertyId,
    required String title,
    required String body,
  }) async {
    return _dataSource.createAnnouncement(
      propertyId: propertyId,
      title: title,
      body: body,
    );
  }

  @override
  Future<void> deleteAnnouncement(String id) async {
    return _dataSource.deleteAnnouncement(id);
  }
}
