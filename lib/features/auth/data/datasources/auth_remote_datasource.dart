// lib/features/auth/data/datasources/auth_remote_datasource.dart
import 'package:dio/dio.dart';
import '../../../../core/network/app_exception.dart';
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
    try {
      final response = await _dio.post(
        '/api/v1/auth/login',
        data: request.toJson(),
      );
      final responseData = response.data['data'] as Map<String, dynamic>? ??
          response.data as Map<String, dynamic>;
      return AuthResponseModel.fromJson(responseData);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  @override
  Future<AuthResponseModel> register(RegisterRequestModel request) async {
    try {
      final response = await _dio.post(
        '/api/v1/auth/register',
        data: request.toJson(),
      );
      final responseData = response.data['data'] as Map<String, dynamic>? ??
          response.data as Map<String, dynamic>;
      return AuthResponseModel.fromJson(responseData);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  @override
  Future<UserModel> getMe() async {
    try {
      final response = await _dio.get('/api/v1/auth/me');
      final responseData = response.data['data'] as Map<String, dynamic>? ??
          response.data as Map<String, dynamic>;
      return UserModel.fromJson(responseData);
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }

  @override
  Future<void> revokeToken() async {
    final refreshToken = await SecureStorage.getRefreshToken();
    if (refreshToken == null) return;
    try {
      await _dio.post(
        '/api/v1/auth/revoke-token',
        data: {'refreshToken': refreshToken},
      );
    } on DioException catch (e) {
      throw AppException.fromDioError(e);
    }
  }
}
