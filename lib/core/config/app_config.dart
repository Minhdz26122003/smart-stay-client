// lib/core/config/app_config.dart

/// Cấu hình môi trường ứng dụng.
/// Để thay đổi địa chỉ máy chủ, chỉnh sửa [_devBaseUrl].
/// Tìm IP máy tính bằng lệnh `ipconfig` (Windows) → IPv4 Address.
class AppConfig {
  AppConfig._();

  static const String _devBaseUrl = 'http://192.168.1.3:5043';

  static String get baseUrl => _devBaseUrl;
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
