// lib/features/announcement/data/datasources/announcement_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/announcement_model.dart';

abstract class AnnouncementRemoteDataSource {
  Future<List<AnnouncementModel>> getAnnouncementsByProperty(String propertyId);
  Future<void> createAnnouncement({
    required String propertyId,
    required String title,
    required String body,
  });
  Future<void> deleteAnnouncement(String id);
}

class AnnouncementRemoteDataSourceImpl implements AnnouncementRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<AnnouncementModel>> getAnnouncementsByProperty(
      String propertyId) async {
    try {
      final response =
          await _dio.get('/api/v1/announcements/property/$propertyId');
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((json) =>
              AnnouncementModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  @override
  Future<void> createAnnouncement({
    required String propertyId,
    required String title,
    required String body,
  }) async {
    try {
      await _dio.post('/api/v1/announcements', data: {
        'propertyId': propertyId,
        'title': title,
        'body': body,
      });
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  @override
  Future<void> deleteAnnouncement(String id) async {
    try {
      await _dio.delete('/api/v1/announcements/$id');
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
