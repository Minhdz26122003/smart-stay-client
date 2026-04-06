// lib/features/auth/data/repositories/auth_repository_impl.dart
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

/// Implementation thật của [AuthRepository], kết nối backend qua Dio.
/// Thay thế [MockAuthRepositoryImpl].
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<User> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    final response = await _remoteDataSource.login(
      LoginRequestModel(phoneOrEmail: email, password: password),
    );
    // Lưu session persistent tuỳ thuộc vào rememberMe
    await SecureStorage.saveRememberMe(rememberMe);
    await SecureStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return response.user.toEntity();
  }

  @override
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    final response = await _remoteDataSource.register(
      RegisterRequestModel(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      ),
    );
    await SecureStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    return response.user.toEntity();
  }

  @override
  Future<User?> getCurrentUser() async {
    final isRememberMe = await SecureStorage.isRememberMe();
    if (!isRememberMe) {
      await logout(); // Xóa sạch token nếu phiên trước không yêu cầu ghi nhớ
      return null;
    }

    // Không có token → chắc chắn chưa đăng nhập
    final token = await SecureStorage.getAccessToken();
    if (token == null) return null;
    try {
      final userModel = await _remoteDataSource.getMe();
      return userModel.toEntity();
    } catch (_) {
      // Token hết hạn hoặc không hợp lệ → coi như chưa đăng nhập
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Báo server thu hồi token
      await _remoteDataSource.revokeToken();
    } catch (_) {
      // Nếu server báo lỗi vẫn xóa token cục bộ
    } finally {
      await SecureStorage.clearTokens();
    }
  }
}
