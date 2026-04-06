// lib/features/auth/data/models/login_request_model.dart

class LoginRequestModel {
  final String phoneOrEmail;
  final String password;
  final String deviceInfo;

  const LoginRequestModel({
    required this.phoneOrEmail,
    required this.password,
    this.deviceInfo = 'smart_stay_mobile_app',
  });

  Map<String, dynamic> toJson() => {
        'phoneOrEmail': phoneOrEmail,
        'password': password,
        'deviceInfo': deviceInfo,
      };
}
