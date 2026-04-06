import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    required String fullName,
    required String role, // 'landlord' | 'tenant' | 'seeker'
    String? avatarUrl,
    String? phoneNumber,
  }) = _User;
}
