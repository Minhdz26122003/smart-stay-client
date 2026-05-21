// lib/core/config/app_config.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Cấu hình môi trường ứng dụng với auto-detection
/// 
/// Hệ thống tự động chọn URL phù hợp:
/// - Emulator: Tự động dùng localhost (10.0.2.2 cho Android, localhost cho iOS)
/// - Physical Device: Dùng hostname của máy (hoạt động trên mọi mạng)
/// 
/// Lợi ích: Không cần thay đổi gì khi chuyển mạng (nhà ↔ công ty)
class AppConfig {
  AppConfig._();

  /// Lấy hostname của máy từ .env (ví dụ: DESKTOP-ABC123.local)
  static String get _physicalDeviceHostname => 
      dotenv.get('PHYSICAL_DEVICE_HOSTNAME', fallback: 'localhost');
  
  /// Lấy port từ .env
  static String get _apiPort => dotenv.get('API_PORT', fallback: '5043');

  /// URL cho Android Emulator (10.0.2.2 = localhost của máy host)
  static String get _androidEmulatorUrl => 'http://10.0.2.2:$_apiPort';
  
  /// URL cho iOS Simulator
  static String get _iosSimulatorUrl => 'http://localhost:$_apiPort';
  
  /// URL cho Physical Device (dùng hostname, hoạt động trên mọi mạng)
  static String get _physicalDeviceUrl => 'http://$_physicalDeviceHostname:$_apiPort';

  /// Tự động phát hiện và trả về URL phù hợp
  static String get baseUrl {
    // Nếu đang chạy trên web, dùng localhost
    if (kIsWeb) {
      return 'http://localhost:$_apiPort';
    }

    // Kiểm tra platform
    if (Platform.isAndroid) {
      // Android: Kiểm tra xem có phải emulator không
      return _isAndroidEmulator() ? _androidEmulatorUrl : _physicalDeviceUrl;
    } else if (Platform.isIOS) {
      // iOS: Kiểm tra xem có phải simulator không
      return _isIOSSimulator() ? _iosSimulatorUrl : _physicalDeviceUrl;
    }

    // Fallback: Dùng physical device URL
    return _physicalDeviceUrl;
  }

  /// Kiểm tra xem có phải Android Emulator không
  static bool _isAndroidEmulator() {
    // Kiểm tra environment variables đặc trưng của emulator
    final androidEmulator = Platform.environment['ANDROID_EMULATOR'];
    if (androidEmulator != null) return true;

    // Kiểm tra FLUTTER_EMULATOR (có thể set thủ công nếu cần)
    return Platform.environment['FLUTTER_EMULATOR'] == 'true';
  }

  /// Kiểm tra xem có phải iOS Simulator không
  static bool _isIOSSimulator() {
    // iOS Simulator có environment variable này
    final simulatorRoot = Platform.environment['SIMULATOR_ROOT'];
    if (simulatorRoot != null) return true;

    // Hoặc kiểm tra FLUTTER_SIMULATOR
    return Platform.environment['FLUTTER_SIMULATOR'] == 'true';
  }

  /// Lấy URL hiện tại đang dùng (để debug)
  static String get currentUrl => baseUrl;

  /// Kiểm tra xem đang dùng emulator/simulator không
  static bool get isEmulator {
    if (kIsWeb) return false;
    if (Platform.isAndroid) return _isAndroidEmulator();
    if (Platform.isIOS) return _isIOSSimulator();
    return false;
  }

  /// Timeout cho kết nối
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 45);

  /// In thông tin cấu hình (để debug)
  static void printConfig() {
    if (kDebugMode) {
      print('╔════════════════════════════════════════╗');
      print('║     Smart Stay - Configuration        ║');
      print('╠════════════════════════════════════════╣');
      print('║ Platform: ${_getPlatformName().padRight(28)}║');
      print('║ Device Type: ${(isEmulator ? 'Emulator/Simulator' : 'Physical Device').padRight(23)}║');
      print('║ Base URL: ${baseUrl.padRight(28)}║');
      print('║ Hostname: ${_physicalDeviceHostname.padRight(28)}║');
      print('║ API Port: ${_apiPort.padRight(28)}║');
      print('╚════════════════════════════════════════╝');
    }
  }

  static String _getPlatformName() {
    if (kIsWeb) return 'Web';
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }
}
