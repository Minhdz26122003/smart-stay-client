// lib/features/room/data/datasources/room_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/room_model.dart';
import '../models/room_detail_model.dart';

abstract class RoomRemoteDataSource {
  Future<List<RoomModel>> getRoomsByProperty(String propertyId);
  Future<RoomDetailModel> getRoomDetail(String roomId);
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<RoomModel>> getRoomsByProperty(String propertyId) async {
    try {
      final response = await _dio.get('/api/v1/rooms/property/$propertyId');
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((json) => RoomModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  @override
  Future<RoomDetailModel> getRoomDetail(String roomId) async {
    try {
      final response = await _dio.get('/api/v1/rooms/$roomId');
      final data = response.data['data'] as Map<String, dynamic>;
      return RoomDetailModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
