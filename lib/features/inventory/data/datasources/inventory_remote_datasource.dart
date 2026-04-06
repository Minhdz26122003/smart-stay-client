// lib/features/inventory/data/datasources/inventory_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/inventory_item_model.dart';

abstract class InventoryRemoteDataSource {
  Future<List<InventoryItemModel>> getInventoryByContract(String contractId);
}

class InventoryRemoteDataSourceImpl implements InventoryRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<InventoryItemModel>> getInventoryByContract(String contractId) async {
    try {
      final response = await _dio.get('/api/v1/inventory-items/contract/$contractId');
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((json) => InventoryItemModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
