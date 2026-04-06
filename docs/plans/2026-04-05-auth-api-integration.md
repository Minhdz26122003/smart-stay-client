# Auth API Integration — Implementation Plan

> **For Antigravity:** REQUIRED WORKFLOW: Use `.agent/workflows/execute-plan.md` to execute this plan in single-flow mode.

**Goal:** Thay thế `MockAuthRepositoryImpl` bằng implementation thật dùng Dio + `flutter_secure_storage`, hỗ trợ auto-refresh token và session restore khi khởi động app.

**Architecture:** Clean Architecture feature-first. Tầng `data` giao tiếp với REST API qua `DioClient` (singleton có `AuthInterceptor`). `AuthRepositoryImpl` implements interface `AuthRepository` từ domain. DI được wire qua `GetIt`.

**Tech Stack:** `dio`, `flutter_secure_storage`, `pretty_dio_logger`, `get_it`, `freezed`, `json_serializable`

---

## Task 1: Thêm dependencies vào pubspec.yaml

**Files:**
- Modify: `pubspec.yaml`

**Step 1: Thêm packages**

```yaml
dependencies:
  # ... existing ...
  dio: any
  flutter_secure_storage: any
  pretty_dio_logger: any
```

**Step 2: Chạy pub get**

```bash
flutter pub get
```

Expected: Resolve packages thành công, không có lỗi conflict.

**Step 3: Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "feat: add dio, flutter_secure_storage packages"
```

---

## Task 2: Tạo AppConfig

**Files:**
- Create: `lib/core/config/app_config.dart`

**Step 1: Viết AppConfig**

```dart
// lib/core/config/app_config.dart
class AppConfig {
  AppConfig._();

  // Đổi IP này khi chuyển mạng (ipconfig → IPv4 Address)
  static const String _devBaseUrl = 'http://192.168.1.4:5043';

  static String get baseUrl => _devBaseUrl;
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
```

**Step 2: Commit**

```bash
git add lib/core/config/app_config.dart
git commit -m "feat: add AppConfig with base URL"
```

---

## Task 3: Tạo SecureStorage wrapper

**Files:**
- Create: `lib/core/storage/secure_storage.dart`

**Step 1: Viết SecureStorage**

```dart
// lib/core/storage/secure_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  SecureStorage._();

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(key: _accessTokenKey, value: accessToken),
      _storage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  static Future<String?> getAccessToken() =>
      _storage.read(key: _accessTokenKey);

  static Future<String?> getRefreshToken() =>
      _storage.read(key: _refreshTokenKey);

  static Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
    ]);
  }
}
```

**Step 2: Commit**

```bash
git add lib/core/storage/secure_storage.dart
git commit -m "feat: add SecureStorage wrapper"
```

---

## Task 4: Tạo AuthInterceptor

**Files:**
- Create: `lib/core/network/auth_interceptor.dart`

**Step 1: Viết AuthInterceptor**

```dart
// lib/core/network/auth_interceptor.dart
import 'package:dio/dio.dart';
import '../storage/secure_storage.dart';
import '../config/app_config.dart';

class AuthInterceptor extends Interceptor {
  // Dio riêng cho refresh (tránh vòng lặp vô hạn)
  final _refreshDio = Dio(BaseOptions(baseUrl: AppConfig.baseUrl));

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
    // Chỉ xử lý 401 và không phải request refresh-token (tránh loop)
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains('refresh-token')) {
      try {
        final refreshToken = await SecureStorage.getRefreshToken();
        if (refreshToken == null) {
          await SecureStorage.clearTokens();
          return handler.next(err);
        }

        // Gọi refresh
        final response = await _refreshDio.post(
          '/api/v1/auth/refresh-token',
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['accessToken'] as String;
        final newRefreshToken = response.data['refreshToken'] as String;

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
        // Refresh thất bại → xóa token, để UI xử lý logout
        await SecureStorage.clearTokens();
        return handler.next(err);
      }
    }
    handler.next(err);
  }
}
```

**Step 2: Commit**

```bash
git add lib/core/network/auth_interceptor.dart
git commit -m "feat: add AuthInterceptor with auto-refresh logic"
```

---

## Task 5: Tạo DioClient

**Files:**
- Create: `lib/core/network/dio_client.dart`

**Step 1: Viết DioClient**

```dart
// lib/core/network/dio_client.dart
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../config/app_config.dart';
import 'auth_interceptor.dart';

class DioClient {
  DioClient._();

  static final Dio _dio = _createDio();

  static Dio get instance => _dio;

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
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        compact: false,
      ),
    ]);

    return dio;
  }
}
```

**Step 2: Commit**

```bash
git add lib/core/network/dio_client.dart
git commit -m "feat: add DioClient singleton"
```

---

## Task 6: Tạo Auth Models (Request & Response)

**Files:**
- Create: `lib/features/auth/data/models/login_request_model.dart`
- Create: `lib/features/auth/data/models/register_request_model.dart`
- Create: `lib/features/auth/data/models/auth_response_model.dart`

**Step 1: LoginRequestModel**

```dart
// lib/features/auth/data/models/login_request_model.dart
class LoginRequestModel {
  final String email;
  final String password;

  const LoginRequestModel({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
```

**Step 2: RegisterRequestModel**

```dart
// lib/features/auth/data/models/register_request_model.dart
class RegisterRequestModel {
  final String fullName;
  final String email;
  final String password;
  final String role;

  const RegisterRequestModel({
    required this.fullName,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'email': email,
    'password': password,
    'role': role,
  };
}
```

**Step 3: AuthResponseModel**

Dựa trên mockdata.sql, backend trả về:
- accessToken (String)
- refreshToken (String)
- user object: { id, email, fullName, role, phoneNumber, avatarUrl }

```dart
// lib/features/auth/data/models/auth_response_model.dart
import '../../domain/entities/user.dart';

class AuthResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  const AuthResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}

class UserModel {
  final String id;
  final String email;
  final String fullName;
  final String role;
  final String? phoneNumber;
  final String? avatarUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.role,
    this.phoneNumber,
    this.avatarUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id']?.toString() ?? '',
    email: json['email'] as String? ?? '',
    fullName: json['fullName'] as String? ?? '',
    role: json['role'] as String? ?? '',
    phoneNumber: json['phoneNumber'] as String?,
    avatarUrl: json['avatarUrl'] as String?,
  );

  User toEntity() => User(
    id: id,
    email: email,
    fullName: fullName,
    role: role,
    phoneNumber: phoneNumber,
    avatarUrl: avatarUrl,
  );
}
```

**Step 4: Commit**

```bash
git add lib/features/auth/data/models/
git commit -m "feat: add auth request/response models"
```

---

## Task 7: Tạo AuthRemoteDataSource

**Files:**
- Create: `lib/features/auth/data/datasources/auth_remote_datasource.dart`

**Step 1: Viết datasource**

```dart
// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/storage/secure_storage.dart';
import '../models/auth_response_model.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login(LoginRequestModel request);
  Future<AuthResponseModel> register(RegisterRequestModel request);
  Future<UserModel> getMe();
  Future<void> revokeToken();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio = DioClient.instance;

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) async {
    final response = await _dio.post(
      '/api/v1/auth/login',
      data: request.toJson(),
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    final response = await _dio.post(
      '/api/v1/auth/register',
      data: request.toJson(),
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<UserModel> getMe() async {
    final response = await _dio.get('/api/v1/auth/me');
    return UserModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> revokeToken() async {
    final refreshToken = await SecureStorage.getRefreshToken();
    if (refreshToken != null) {
      await _dio.post(
        '/api/v1/auth/revoke-token',
        data: {'refreshToken': refreshToken},
      );
    }
  }
}
```

**Step 2: Commit**

```bash
git add lib/features/auth/data/datasources/
git commit -m "feat: add AuthRemoteDataSource"
```

---

## Task 8: Tạo AuthRepositoryImpl (thay thế Mock)

**Files:**
- Create: `lib/features/auth/data/repositories/auth_repository_impl.dart`

**Step 1: Viết AuthRepositoryImpl**

```dart
// lib/features/auth/data/repositories/auth_repository_impl.dart
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/login_request_model.dart';
import '../models/register_request_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(
      LoginRequestModel(email: email, password: password),
    );
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
    final token = await SecureStorage.getAccessToken();
    if (token == null) return null;
    try {
      final userModel = await _remoteDataSource.getMe();
      return userModel.toEntity();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.revokeToken();
    } catch (_) {
      // Ignore error, clear local tokens regardless
    } finally {
      await SecureStorage.clearTokens();
    }
  }
}
```

**Step 2: Commit**

```bash
git add lib/features/auth/data/repositories/auth_repository_impl.dart
git commit -m "feat: add AuthRepositoryImpl with real API"
```

---

## Task 9: Cập nhật injection_container.dart

**Files:**
- Modify: `lib/core/di/injection_container.dart`

**Step 1: Wire DI thật**

```dart
// lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDI() async {
  // BLoCs
  sl.registerFactory(() => AuthBloc(authRepository: sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );

  // Dummy reg to pass test
  sl.registerLazySingleton<String>(() => 'Ready', instanceName: 'test_ready');
}
```

**Step 2: Commit**

```bash
git add lib/core/di/injection_container.dart
git commit -m "feat: wire real AuthRepository in DI container"
```

---

## Task 10: Cập nhật main.dart — Session Restore

**Files:**
- Modify: `lib/main.dart`

**Step 1: Xem nội dung main.dart hiện tại**

Đọc file để không mất code hiện có.

**Step 2: Đảm bảo AuthBloc.add(checkAuthSession) được gọi khi app khởi động**

Tìm chỗ tạo `BlocProvider<AuthBloc>` và thêm:

```dart
BlocProvider(
  create: (context) => sl<AuthBloc>()
    ..add(const AuthEvent.checkAuthSession()), // ← thêm dòng này
),
```

Điều này sẽ tự động:
1. Đọc accessToken từ SecureStorage
2. Nếu có → gọi `GET /api/v1/auth/me`
3. Nếu OK → `emit(Authenticated)` → GoRouter redirect đến dashboard
4. Nếu fail → `emit(Unauthenticated)` → GoRouter redirect đến `/welcome`

**Step 3: Commit**

```bash
git add lib/main.dart
git commit -m "feat: restore auth session on app start"
```

---

## Task 11: Xử lý lỗi Dio — AppException

**Files:**
- Create: `lib/core/network/app_exception.dart`

**Step 1: Viết helper map DioException → thông báo tiếng Việt**

```dart
// lib/core/network/app_exception.dart
import 'package:dio/dio.dart';

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
        return const AppException('Không thể kết nối máy chủ. Kiểm tra mạng.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;
        final serverMsg = data is Map ? data['message'] ?? data['error'] : null;
        if (serverMsg != null) return AppException(serverMsg.toString());
        return switch (statusCode) {
          400 => const AppException('Dữ liệu không hợp lệ.'),
          401 => const AppException('Phiên đăng nhập hết hạn.'),
          403 => const AppException('Bạn không có quyền thực hiện.'),
          404 => const AppException('Không tìm thấy dữ liệu.'),
          409 => const AppException('Email đã được sử dụng.'),
          500 => const AppException('Lỗi máy chủ. Vui lòng thử lại sau.'),
          _ => const AppException('Đã có lỗi xảy ra.'),
        };
      default:
        return const AppException('Đã có lỗi không xác định.');
    }
  }

  @override
  String toString() => message;
}
```

**Step 2: Áp dụng vào datasource — wrap DioException**

Trong `auth_remote_datasource.dart`, bọc mỗi method:

```dart
try {
  final response = await _dio.post(...);
  return AuthResponseModel.fromJson(response.data);
} on DioException catch (e) {
  throw AppException.fromDioError(e);
}
```

**Step 3: Commit**

```bash
git add lib/core/network/app_exception.dart lib/features/auth/data/datasources/
git commit -m "feat: add AppException and error handling in datasource"
```

---

## Task 12: Kiểm tra end-to-end

**Step 1: Đảm bảo backend đang chạy**

```bash
# Trên máy Windows, backend chạy tại cổng 5043
# Kiểm tra bằng cách mở trình duyệt: http://localhost:5043/swagger
```

**Step 2: Chạy app trên thiết bị thật**

```bash
flutter run
```

**Step 3: Test Login flow**

- Mở app → màn Login
- Nhập email/password từ mockdata.sql (ví dụ user đã seed trong DB)
- Expected: Login thành công → điều hướng vào dashboard đúng role

**Step 4: Test Session Restore**

- Sau khi login thành công → tắt app hoàn toàn → mở lại
- Expected: App bỏ qua màn Login → vào thẳng dashboard (không hỏi đăng nhập lại)

**Step 5: Test Logout**

- Bấm Đăng xuất ở Profile screen
- Expected: Token bị xóa → redirect về `/welcome`

**Step 6: Commit cuối**

```bash
git add .
git commit -m "feat: complete Auth API integration with Dio + SecureStorage"
```
