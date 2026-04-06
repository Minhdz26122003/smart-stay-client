import 'dart:async';
import '../../../../core/storage/secure_storage.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

/// Mock implementation — sẽ được thay thế bằng API thật khi backend sẵn sàng.
class MockAuthRepositoryImpl implements AuthRepository {
  // Dữ liệu mock cố định
  static const _mockUsers = [
    {
      'id': 'u001',
      'email': 'landlord@smartstay.vn',
      'password': '123456',
      'fullName': 'Nguyễn Văn An',
      'role': 'landlord',
      'avatarUrl': null,
      'phoneNumber': '0901234567',
    },
    {
      'id': 'u002',
      'email': 'tenant@smartstay.vn',
      'password': '123456',
      'fullName': 'Trần Thị Bình',
      'role': 'tenant',
      'avatarUrl': null,
      'phoneNumber': '0907654321',
    },
    {
      'id': 'u003',
      'email': 'seeker@smartstay.vn',
      'password': '123456',
      'fullName': 'Lê Văn Cường',
      'role': 'seeker',
      'avatarUrl': null,
      'phoneNumber': '0909988776',
    },
  ];

  User? _currentUser;

  @override
  Future<User> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    // Giả lập độ trễ mạng
    await Future.delayed(const Duration(milliseconds: 800));

    final match = _mockUsers.where(
      (u) => u['email'] == email && u['password'] == password,
    );

    if (match.isEmpty) {
      throw Exception('Email hoặc mật khẩu không đúng.');
    }

    final userData = match.first;
    _currentUser = User(
      id: userData['id']!,
      email: userData['email']!,
      fullName: userData['fullName']!,
      role: userData['role']!,
      avatarUrl: userData['avatarUrl'],
      phoneNumber: userData['phoneNumber'],
    );
    return _currentUser!;
  }

  @override
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _currentUser = User(
      id: 'u${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      fullName: fullName,
      role: role,
    );
    return _currentUser!;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    final isRememberMe = await SecureStorage.isRememberMe();
    if (!isRememberMe) {
      await logout();
      return null;
    }
    await SecureStorage.getAccessToken(); // Giả lập đọc token
    return _currentUser;
  }
}
