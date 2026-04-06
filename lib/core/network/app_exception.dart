// lib/core/network/app_exception.dart
import 'package:dio/dio.dart';

/// Exception thống nhất cho toàn app.
/// Map DioException → thông báo lỗi tiếng Việt thân thiện.
class AppException implements Exception {
  final String message;
  const AppException(this.message);

  factory AppException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const AppException('Kết nối quá thời gian. Vui lòng thử lại.');
      case DioExceptionType.connectionError:
        return const AppException(
            'Không thể kết nối máy chủ. Vui lòng kiểm tra kết nối mạng.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        // Ưu tiên dùng message từ server nếu có
        final serverMsg =
            data is Map ? (data['message'] ?? data['error']) : null;
        if (serverMsg != null) return AppException(serverMsg.toString());
        return switch (statusCode) {
          400 => const AppException('Dữ liệu không hợp lệ.'),
          401 => const AppException('Phiên đăng nhập đã hết hạn.'),
          403 => const AppException('Bạn không có quyền thực hiện thao tác này.'),
          404 => const AppException('Không tìm thấy dữ liệu.'),
          409 => const AppException('Email này đã được sử dụng.'),
          500 => const AppException('Lỗi máy chủ. Vui lòng thử lại sau.'),
          _ => const AppException('Đã có lỗi xảy ra. Vui lòng thử lại.'),
        };
      default:
        return const AppException('Đã có lỗi không xác định.');
    }
  }

  @override
  String toString() => message;
}
