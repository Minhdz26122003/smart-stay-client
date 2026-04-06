// lib/core/network/auth_interceptor.dart
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../storage/secure_storage.dart';

/// Interceptor tự động:
/// 1. Inject "Authorization: Bearer accessToken" vào mọi request
/// 2. Khi nhận 401 → tự động gọi refresh-token
/// 3. Nếu refresh thành công → retry request gốc với token mới
/// 4. Nếu refresh thất bại → xóa token (UI sẽ bắt và điều hướng logout)
class AuthInterceptor extends Interceptor {
  // Dùng Dio riêng để tránh interceptor gọi đệ quy chính nó
  final _refreshDio = Dio(
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

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    final isRefreshRequest =
        err.requestOptions.path.contains('refresh-token');

    if (isUnauthorized && !isRefreshRequest) {
      try {
        final refreshToken = await SecureStorage.getRefreshToken();
        if (refreshToken == null) {
          await SecureStorage.clearTokens();
          return handler.next(err);
        }

        // Gọi endpoint refresh
        final response = await _refreshDio.post(
          '/api/v1/auth/refresh-token',
          data: {'refreshToken': refreshToken},
        );

        final data = response.data as Map<String, dynamic>;
        final newAccessToken = data['accessToken'] as String;
        final newRefreshToken = data['refreshToken'] as String;

        await SecureStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        // Retry request gốc với token mới
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newAccessToken';
        final retryResponse = await _refreshDio.fetch(opts);
        return handler.resolve(retryResponse);
      } catch (_) {
        // Refresh thất bại → xóa token, ném lỗi 401 để UI xử lý logout
        await SecureStorage.clearTokens();
        return handler.next(err);
      }
    }

    handler.next(err);
  }
}
