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
