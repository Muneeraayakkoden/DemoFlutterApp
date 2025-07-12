import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../constants/api_urls.dart';
import '../../../utils/shared_utils.dart';
import 'dart:developer' as developer;

class ProfileProvider extends ChangeNotifier {
  String _name = '';
  String _phoneNumber = '';
  bool _isLoading = false;
  String _error = '';

  String get name => _name;
  String get phoneNumber => _phoneNumber;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchProfileData() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      final authToken = await SharedUtils.getString('auth_token');
      if (authToken.isEmpty) {
        _error = 'Not authenticated';
        _isLoading = false;
        notifyListeners();
        return;
      }

      developer.log('Fetching profile data...', name: 'ProfileProvider');
      developer.log('Using token: $authToken', name: 'ProfileProvider');

      final response = await http.get(
        Uri.parse(ApiUrls.getProfileMe()),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      developer.log(
        'Response status: ${response.statusCode}', name: 'ProfileProvider',
      );
      developer.log(
        'Response body: ${response.body}', name: 'ProfileProvider',
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        final userData = responseData['user'];
        _name = userData['name'] ?? '';
        _phoneNumber = userData['phoneNumber'] ?? '';
        _error = '';
        developer.log('Profile data fetched successfully',
          name: 'ProfileProvider',
        );
      } else {
        _error = responseData['message'] ?? 'Failed to load profile data';
        developer.log('Error fetching profile: $_error',
          name: 'ProfileProvider',
        );
      }
    } catch (e) {
      _error = 'An error occurred while fetching profile data';
      developer.log('Exception fetching profile: $e',
        name: 'ProfileProvider',
        error: e,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setUserInfo({
    required String userType,
    required String userName,
    required String phone,
    required String department,
    required String designation,
    required bool isDeptHead,
  }) {
    _name = userName;
    _phoneNumber = phone;
    notifyListeners();
  }
}
