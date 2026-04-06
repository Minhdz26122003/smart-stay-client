// lib/features/property/data/datasources/property_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/property_model.dart';

abstract class PropertyRemoteDataSource {
  Future<List<PropertyModel>> getProperties();
}

class PropertyRemoteDataSourceImpl implements PropertyRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<PropertyModel>> getProperties() async {
    try {
      final response = await _dio.get('/api/v1/properties');
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((json) => PropertyModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
