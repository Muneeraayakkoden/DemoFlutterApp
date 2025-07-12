import 'package:flutter/material.dart';
import '../service/login_service.dart';
import 'package:toastification/toastification.dart';
import '../../../utils/navigation_helper.dart';
import '../../../routes/routes_names.dart';
import '../../../utils/shared_utils.dart';
import 'dart:developer' as developer;

class AuthProvider extends ChangeNotifier {
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

  // Auth state
  bool _isLoggedIn = false;
  String _userType = '';
  bool _isDeptHead = false;
  String _department = '';
  String _designation = '';
  String _userId = '';
  String _userName = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userType => _userType;
  bool get isDeptHead => _isDeptHead;
  String get department => _department;
  String get designation => _designation;
  String get userId => _userId;
  String get userName => _userName;

  // Initialize auth state
  Future<void> initializeAuth() async {
    final authToken = await SharedUtils.getString('auth_token');
    _isLoggedIn = authToken.isNotEmpty;
    if (_isLoggedIn) {
      _userType = await SharedUtils.getString('user_type');
      _isDeptHead = await SharedUtils.getBoolean('is_dept_head');
      _department = await SharedUtils.getString('user_department');
      _designation = await SharedUtils.getString('user_designation');
      _userId = await SharedUtils.getString('user_id');
      _userName = await SharedUtils.getString('user_name');
    }
    notifyListeners();
  }

  // Reset internal state
  void reset() {
    phoneController.clear();
    usernameController.clear();
    otpController.clear();
    isPhoneEntered = false;
    selectedRole = 'User';
  }

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
    final phone = phoneController.text.trim();
    final otp = otpController.text.trim();

    if (!isValidPhoneNumber(phone)) {
      return 'Invalid phone number';
    }

    if (otp.length != 6) {
      return 'Please enter a valid 6-digit OTP';
    }

    try {
      isLoading = true;
      notifyListeners();

      final response = await _loginService.validateOtp(phone, otp);
      if (!response.success) {
        // Clear OTP field on invalid/expired OTP
        otpController.clear();
        otpFocusNode.requestFocus();
        return response.message;
      }

      // Save auth token and user data
      if (response.token != null) {
        await SharedUtils.setString('auth_token', response.token!);
        _isLoggedIn = true;
      }

      if (response.userData != null) {
        final userData = response.userData!;
        await SharedUtils.setString('user_type', 'User');
        await SharedUtils.setBoolean(
          'is_dept_head',
          userData['isDeptHead'] ?? false,
        );
        await SharedUtils.setString(
          'user_department',
          userData['department'] ?? '',
        );
        await SharedUtils.setString(
          'user_designation',
          userData['designation'] ?? '',
        );
        await SharedUtils.setString(
          'user_id',
          userData['id']?.toString() ?? '',
        );
        await SharedUtils.setString('user_name', userData['name'] ?? '');

        // Update internal state
        _userType = 'User';
        _isDeptHead = userData['isDeptHead'] ?? false;
        _department = userData['department'] ?? '';
        _designation = userData['designation'] ?? '';
        _userId = userData['id']?.toString() ?? '';
        _userName = userData['name'] ?? '';
      }

      notifyListeners();
      return null;
    } catch (e) {
      // Clear OTP field on error
      otpController.clear();
      return 'Failed to validate OTP. Please try again.';
    } finally {
      isLoading = false;
      notifyListeners();
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

    // Clear existing OTP when resending
    otpController.clear();

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

  Future<void> logout() async {
    try {
      developer.log('Logging out user...', name: 'AuthProvider');

      // Clear general tokens and user data
      await SharedUtils.setString('auth_token', '');
      await SharedUtils.setString('user_type', '');
      await SharedUtils.setBoolean('is_dept_head', false);
      await SharedUtils.setString('user_department', '');
      await SharedUtils.setString('user_designation', '');
      await SharedUtils.setString('user_id', '');
      await SharedUtils.setString('user_name', '');

      // Reset internal state
      _isLoggedIn = false;
      _userType = '';
      _isDeptHead = false;
      _department = '';
      _designation = '';
      _userId = '';
      _userName = '';
      reset();

      developer.log('Logout successful - all tokens and data cleared',
        name: 'AuthProvider',
      );

      notifyListeners();
    } catch (e) {
      developer.log('Error during logout: $e',
        name: 'AuthProvider',
        error: e,
      );
      rethrow;
    }
  }

  Future<void> handleLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must make a choice
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Logout'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (shouldLogout ?? false) {
      try {
        await logout();
        if (!context.mounted) return;

        // Clear navigation stack and go to login
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil(RouteNames.login, (route) => false);
      } catch (e) {
        if (!context.mounted) return;
        _showToast(context, 'Failed to logout. Please try again.', false);
      }
    }
  }
}
