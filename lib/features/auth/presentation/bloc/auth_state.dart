import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'auth_state.freezed.dart';

@freezed
class AuthState with _$AuthState {
  /// Trạng thái ban đầu, chưa xác định
  const factory AuthState.initial() = _Initial;

  /// Đang xử lý (loading spinner)
  const factory AuthState.loading() = _Loading;

  /// Đã xác thực thành công
  const factory AuthState.authenticated({required User user}) = _Authenticated;

  /// Chưa xác thực (khách)
  const factory AuthState.unauthenticated() = _Unauthenticated;

  /// Đã xảy ra lỗi
  const factory AuthState.failure({required String message}) = _Failure;
}
