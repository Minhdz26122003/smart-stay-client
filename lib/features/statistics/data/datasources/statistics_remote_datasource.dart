// lib/features/statistics/data/datasources/statistics_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/finance_summary_model.dart';
import '../../../../core/network/app_exception.dart';

abstract class StatisticsRemoteDataSource {
  Future<FinanceSummaryModel> getFinanceSummary();
}

class StatisticsRemoteDataSourceImpl implements StatisticsRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<FinanceSummaryModel> getFinanceSummary() async {
    try {
      final response = await _dio.get('/api/v1/statistics/finance-summary');
      if (response.statusCode == 200 && response.data['success'] == true) {
        return FinanceSummaryModel.fromJson(response.data['data']);
      } else {
        throw AppException(response.data['message'] ?? 'Failed to get finance summary');
      }
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    } catch (e) {
      throw AppException(e.toString());
    }
  }
}
