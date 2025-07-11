import 'package:flutter/material.dart';
import '../model/login_model.dart';
import '../service/login_service.dart';
import 'package:toastification/toastification.dart';
import '../../../utils/navigation_helper.dart';
import '../../../routes/routes_names.dart';

class LoginProvider extends ChangeNotifier {
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final otpController = TextEditingController();

  String selectedRole = 'User';
  bool isPhoneEntered = false;
  bool get isUserRole => selectedRole == 'User';
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode otpFocusNode = FocusNode();
  bool isLoading = false;
  final LoginService _loginService = LoginService();

  bool isValidPhoneNumber(String? value) {
    if (value == null || value.isEmpty) return false;
    return RegExp(r'^[0-9]{10}$').hasMatch(value);
  }

  bool isValidUsername(String? value) {
    return value != null && value.isNotEmpty && value.length >= 3;
  }

  String? getFieldValidationMessage(String? value) {
    if (isUserRole) {
      return isValidPhoneNumber(value)
          ? null
          : '1.Enter a valid 10-digit phone number';
    } else {
      return isValidUsername(value)
          ? null
          : 'Username must be at least 3 characters';
    }
  }

  Future<String?> sendOtp() async {
    try {
      final phone = phoneController.text.trim();
      if (!isValidPhoneNumber(phone)) {
        return '2.Enter a valid 10-digit phone number';
      }

      isLoading = true;
      notifyListeners();

      // Simply send the phone number to the service
      final response = await _loginService.sendOtp(phone);
      if (response.success) {
        isPhoneEntered = true;
        notifyListeners();
        return null;
      } else {
        return response.message;
      }
    } catch (e) {
      return 'Failed to send OTP. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> validateOtp() async {
    final otp = otpController.text.trim();

    if (otp.length != 6) {
      return 'Please enter a valid 6-digit OTP';
    }
    try {
      final response = await _loginService.validateOtp(
        phoneController.text.trim(),
        otpController.text.trim(),
      );
      return response.success ? null : response.message;
    } catch (e) {
      return 'Failed to validate OTP. Please try again.';
    }
  }

  void resetState() {
    isPhoneEntered = false;
    otpController.clear();
    notifyListeners();
  }

  void _showToast(BuildContext context, String message, bool isSuccess) {
    toastification.show(
      context: context,
      title: Text(isSuccess ? 'Success' : 'Error'),
      description: Text(message),
      type: isSuccess ? ToastificationType.success : ToastificationType.error,
      autoCloseDuration: const Duration(seconds: 3),
    );
  }

  void setRole(String? value) {
    if (value != selectedRole) {
      selectedRole = value ?? 'User';
      isPhoneEntered = false;
      phoneController.clear();
      usernameController.clear();
      otpController.clear();
      notifyListeners();
    }
  }

  Future<void> resendOtp(BuildContext context) async {
    if (isLoading) return;
    isLoading = true;
    notifyListeners();

    final result = await sendOtp();
    if (result == null) {
      if (!context.mounted) return;
      _showToast(context, 'OTP resent successfully', true);
      otpFocusNode.requestFocus();
    } else {
      if (!context.mounted) return;
      _showToast(context, result, false);
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> handleContinue(BuildContext context) async {
    if (isLoading) return;

    try {
      if (!isUserRole) {
        if (!isValidUsername(usernameController.text)) {
          _showToast(
            context,
            getFieldValidationMessage(usernameController.text)!,
            false,
          );
          return;
        }
        if (!context.mounted) return;
        navigateReplaceTo(context: context, route: RouteNames.home);
        return;
      }

      // Handle User role
      if (!isPhoneEntered) {
        final cleanPhone = phoneController.text.trim();
        if (!isValidPhoneNumber(cleanPhone)) {
          if (!context.mounted) return;
          _showToast(context, getFieldValidationMessage(cleanPhone)!, false);
          phoneFocusNode.requestFocus();
          return;
        }

        final result = await sendOtp();
        if (result == null) {
          if (!context.mounted) return;
          _showToast(context, 'OTP sent successfully', true);
          otpFocusNode.requestFocus();
        } else {
          if (!context.mounted) return;
          _showToast(context, result, false);
          phoneFocusNode.requestFocus();
        }
      } else {
        // Second step: Validate OTP
        if (otpController.text.trim().length != 6) {
          if (!context.mounted) return;
          _showToast(context, 'Please enter a valid 6-digit OTP', false);
          otpFocusNode.requestFocus();
          return;
        }

        final result = await validateOtp();
        if (result == null) {
          if (!context.mounted) return;
          _showToast(context, 'Login successful', true);
          navigateReplaceTo(context: context, route: RouteNames.home);
        } else {
          if (!context.mounted) return;
          _showToast(context, result, false);
          otpFocusNode.requestFocus();
        }
      }
    } catch (e) {
      if (!context.mounted) return;
      _showToast(context, 'An error occurred. Please try again.', false);
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    usernameController.dispose();
    otpController.dispose();
    phoneFocusNode.dispose();
    otpFocusNode.dispose();
    super.dispose();
  }
}
