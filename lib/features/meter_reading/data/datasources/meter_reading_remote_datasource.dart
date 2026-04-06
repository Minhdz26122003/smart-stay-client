// lib/features/meter_reading/data/datasources/meter_reading_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/meter_reading_model.dart';

abstract class MeterReadingRemoteDataSource {
  Future<List<MeterReadingModel>> getMeterReadingsByRoom(String roomId);
}

class MeterReadingRemoteDataSourceImpl implements MeterReadingRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<MeterReadingModel>> getMeterReadingsByRoom(String roomId) async {
    try {
      final response = await _dio.get('/api/v1/meter-readings/room/$roomId');
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((json) => MeterReadingModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
