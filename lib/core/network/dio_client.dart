// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import 'auth_interceptor.dart';

/// Singleton Dio client dùng chung cho toàn app.
/// Đã gắn [AuthInterceptor] và [PrettyDioLogger] (chỉ log khi debug).
class DioClient {
  DioClient._();

  static final Dio _instance = _createDio();

  static Dio get instance => _instance;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ),
    ]);

    return dio;
  }
}
