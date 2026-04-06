// lib/core/storage/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Wrapper quanh [FlutterSecureStorage] để lưu/đọc/xóa JWT tokens.
/// Trên Android dùng EncryptedSharedPreferences.
/// Trên iOS dùng Keychain.
class SecureStorage {
  SecureStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _rememberMeKey = 'remember_me'; // <-- Flag to persist session

  /// Lưu cả hai token sau khi login/register/refresh thành công.
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  /// Đọc access token (null nếu chưa login).
  static Future<String?> getAccessToken() =>
      _storage.read(key: _accessTokenKey);

  /// Đọc refresh token (null nếu chưa login).
  static Future<String?> getRefreshToken() =>
      _storage.read(key: _refreshTokenKey);

  /// Đọc cờ "Ghi nhớ đăng nhập"
  static Future<bool> isRememberMe() async {
    final value = await _storage.read(key: _rememberMeKey);
    return value == 'true';
  }

  /// Lưu cờ "Ghi nhớ đăng nhập"
  static Future<void> saveRememberMe(bool value) async {
    await _storage.write(key: _rememberMeKey, value: value.toString());
  }

  /// Xóa tất cả tokens (dùng khi logout hoặc refresh thất bại).
  static Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _rememberMeKey),
    ]);
  }
}
