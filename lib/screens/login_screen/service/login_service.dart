// services/login_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/login_model.dart';
import '../../../constants/api_urls.dart';

class LoginService {
  final Duration _timeout = const Duration(seconds: 60);

  Future<LoginResponse> sendOtp(String phone) async {
    try {
      final url = Uri.parse(ApiUrls.getRequestOtp());

      // Create OTP request with phoneNumber as integer
      final otpRequest = OtpRequest(phoneNumber: int.parse(phone));
      final requestJson = otpRequest.toJson();

      final response = await http
          .post(
            url,
            body: jsonEncode(requestJson),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(
            _timeout,
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return LoginResponse.fromJson(responseBody);
      } else {
        return LoginResponse(
          success: false,
          message:
              responseBody['message'] ??
              responseBody['error'] ??
              'Failed to send OTP. Please try again.',
        );
      }
    } on TimeoutException {
      return LoginResponse(
        success: false,
        message: 'Request timed out. Please check your internet connection.',
      );
    } catch (e) {
      return LoginResponse(
        success: false,
        message:
            e is FormatException
                ? 'Invalid server response. Please try again.'
                : 'Network error: Please check your internet connection.',
      );
    }
  }

  Future<LoginResponse> validateOtp(String phone, String otp) async {
    try {
      final url = Uri.parse(ApiUrls.getVerifyOtp());

      // Create OTP verification request with phoneNumber as integer
      final verifyRequest = OtpVerificationRequest(
        phoneNumber: int.parse(phone),
        otp: otp,
      );
      final requestJson = verifyRequest.toJson();

      final response = await http
          .post(
            url,
            body: jsonEncode(requestJson),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          )
          .timeout(
            _timeout,
            onTimeout: () {
              throw TimeoutException('Request timed out');
            },
          );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return LoginResponse.fromJson(responseBody);
      } else {
        return LoginResponse(
          success: false,
          message:
              responseBody['message'] ??
              responseBody['error'] ??
              'Invalid OTP. Please try again.',
        );
      }
    } on TimeoutException {
      return LoginResponse(
        success: false,
        message: 'Request timed out. Please check your internet connection.',
      );
    } catch (e) {
      return LoginResponse(
        success: false,
        message:
            e is FormatException
                ? 'Invalid server response. Please try again.'
                : 'Network error: Please check your internet connection.',
      );
    }
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  @override
  String toString() => message;
}
