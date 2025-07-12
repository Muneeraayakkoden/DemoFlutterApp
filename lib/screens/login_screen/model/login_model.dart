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

// New class specifically for OTP request
class OtpRequest {
  final int phoneNumber;

  OtpRequest({required this.phoneNumber});

  Map<String, dynamic> toJson() => {'phoneNumber': phoneNumber};
}

// New class for OTP verification request
class OtpVerificationRequest {
  final int phoneNumber;
  final String otp;

  OtpVerificationRequest({required this.phoneNumber, required this.otp});

  Map<String, dynamic> toJson() => {'phoneNumber': phoneNumber, 'otp': otp};
}

class LoginResponse {
  final bool success;
  final String message;
  final String? token;
  final Map<String, dynamic>? userData;

  LoginResponse({
    required this.success,
    required this.message,
    this.token,
    this.userData,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      token: json['token'],
      userData: json['user'],
    );
  }
}
