import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  /// Yêu cầu đăng nhập
  const factory AuthEvent.loginRequested({
    required String email,
    required String password,
    @Default(true) bool rememberMe,
  }) = _LoginRequested;

  /// Yêu cầu đăng ký
  const factory AuthEvent.registerRequested({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) = _RegisterRequested;

  /// Yêu cầu đăng xuất
  const factory AuthEvent.logoutRequested() = _LogoutRequested;

  /// Kiểm tra session đã lưu khi khởi động app
  const factory AuthEvent.checkAuthSession() = _CheckAuthSession;
}
