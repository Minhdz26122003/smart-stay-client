// lib/features/invoice/data/datasources/invoice_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/invoice_model.dart';

abstract class InvoiceRemoteDataSource {
  Future<List<InvoiceModel>> getInvoicesByContract(String contractId);
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<List<InvoiceModel>> getInvoicesByContract(String contractId) async {
    try {
      final response = await _dio.get('/api/v1/invoices/contract/$contractId');
      final data = response.data['data'] as List<dynamic>? ?? [];
      return data
          .map((json) => InvoiceModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
