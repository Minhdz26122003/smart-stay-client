// lib/features/contract/data/datasources/contract_remote_datasource.dart

import 'package:dio/dio.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/contract_model.dart';

abstract class ContractRemoteDataSource {
  Future<ContractModel> createContract(Map<String, dynamic> payload);
  Future<List<ContractModel>> getContractsByRoom(String roomId);
}

class ContractRemoteDataSourceImpl implements ContractRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<ContractModel> createContract(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.post('/api/v1/contracts', data: payload);
      final data = response.data['data'] as Map<String, dynamic>;
      return ContractModel.fromJson(data);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  @override
  Future<List<ContractModel>> getContractsByRoom(String roomId) async {
    try {
      final response = await _dio.get('/api/v1/contracts/room/$roomId');
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((json) => ContractModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
