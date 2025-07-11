class LoginRequest {
  final String role;
  final String phone;
  final String? username;

  LoginRequest({required this.phone, this.username, required this.role});

  Map<String, dynamic> toJson() => {
    'role': role,
    'phone': phone,
    'username': username,
  };
}

class LoginResponse {
  final bool success;
  final String message;

  LoginResponse({required this.success, required this.message});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}
