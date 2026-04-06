// lib/features/auth/data/models/auth_response_model.dart
import '../../domain/entities/user.dart';

/// Ánh xạ response từ /auth/login và /auth/register.
/// Backend trả về: { accessToken, refreshToken, user: { id, email, fullName, role, ... } }
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
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      user: UserModel.fromJson(json),
    );
  }
}

/// Model cho user object trả về từ backend.
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final roles = json['roles'] as List<dynamic>?;
    final role = (roles != null && roles.isNotEmpty)
        ? roles.first.toString().toLowerCase()
        : '';

    return UserModel(
      id: json['userId']?.toString() ?? '',
      email: json['email'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      role: role,
      phoneNumber: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  /// Chuyển đổi sang domain entity để dùng trong BLoC.
  User toEntity() => User(
        id: id,
        email: email,
        fullName: fullName,
        role: role,
        phoneNumber: phoneNumber,
        avatarUrl: avatarUrl,
      );
}
