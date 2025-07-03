// import 'dart:convert';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:hira_plus/utils/shared_utils.dart';
// import 'dart:developer' as developer;
// import 'package:logger/logger.dart';

// class HttpServiceUtils {
//   static final Logger _logger = Logger();
//   static const int timeoutDuration = 45; // seconds
//   static const int maxRetries = 3;

//   /// Fetch data from API with GET request
//   static Future<dynamic> fetchData(String url, bool requiresAuth) async {
//     return _retryRequest(() => _fetchDataInternal(url, requiresAuth));
//   }

//   static Future<dynamic> _fetchDataInternal(
//       String url, bool requiresAuth) async {
//     try {
//       _logger.i('🌐 [HTTP_GET] Starting GET request to: $url');
//       _logger.d('🔐 [HTTP_GET] Requires auth: $requiresAuth');
//       developer.log('🌐 Starting GET request to: $url',
//           name: 'HttpServiceUtils');

//       if (!await checkConnectivity()) {
//         _logger.e('🔌 [HTTP_GET] No internet connection available');
//         throw const HttpException(
//             'No internet connection. Please check your network and try again.');
//       }

//       final headers = <String, String>{
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Connection': 'keep-alive',
//         'Cache-Control': 'no-cache',
//       };

//       if (requiresAuth) {
//         final token = await SharedUtils.getString('auth_token');
//         if (token.isEmpty) {
//           _logger.e('❌ [HTTP_GET] No auth token found');
//           developer.log('❌ No auth token found', name: 'HttpServiceUtils');
//           throw const HttpException(
//               'Authentication token not found. Please login again.');
//         }
//         headers['Authorization'] = 'Bearer $token';
//         _logger.d('🔑 [HTTP_GET] Auth token added to headers');
//       }

//       _logger.d('📋 [HTTP_GET] Request headers: $headers');
//       developer.log('📋 Making authenticated request',
//           name: 'HttpServiceUtils');

//       final uri = Uri.parse(url);
//       _logger.d('🔗 [HTTP_GET] Parsed URI: $uri');

//       final response = await http
//           .get(
//         uri,
//         headers: headers,
//       )
//           .timeout(
//         const Duration(seconds: timeoutDuration),
//         onTimeout: () {
//           _logger.e('⏱️ [HTTP_GET] Request timeout after ${timeoutDuration}s');
//           throw const SocketException(
//               'Connection timeout. Please check your network and try again.');
//         },
//       );

//       _logger.i(
//           '📨 [HTTP_GET] Response received - Status: ${response.statusCode}');
//       _logger.d('📨 [HTTP_GET] Response headers: ${response.headers}');
//       _logger.d('📨 [HTTP_GET] Response body length: ${response.body.length}');
//       developer.log('📨 GET response: ${response.statusCode}',
//           name: 'HttpServiceUtils');

//       return _handleResponse(response, 'GET', url);
//     } on SocketException catch (e) {
//       _logger.e('🔌 [HTTP_GET] Network error: $e');
//       developer.log('🔌 Network error: $e', name: 'HttpServiceUtils', error: e);

//       if (e.toString().contains('timeout') ||
//           e.toString().contains('Connection timeout')) {
//         throw const HttpException(
//             'Connection timeout. Please check your network and try again.');
//       } else {
//         throw const HttpException(
//             'No internet connection. Please check your network.');
//       }
//     } on HttpException catch (e) {
//       _logger.e('🚫 [HTTP_GET] HTTP exception: $e');
//       developer.log('🚫 HTTP exception: $e',
//           name: 'HttpServiceUtils', error: e);
//       rethrow;
//     } on FormatException catch (e) {
//       _logger.e('📝 [HTTP_GET] Format exception: $e');
//       developer.log('📝 Format exception: $e',
//           name: 'HttpServiceUtils', error: e);
//       throw const HttpException(
//           'Invalid response format from server. Please try again.');
//     } catch (e, stackTrace) {
//       _logger.e('💥 [HTTP_GET] Unexpected error: $e');
//       _logger.e('💥 [HTTP_GET] StackTrace: $stackTrace');
//       developer.log('💥 Unexpected GET error: $e',
//           name: 'HttpServiceUtils', error: e, stackTrace: stackTrace);

//       if (e.toString().contains('timeout')) {
//         throw const HttpException(
//             'Connection timeout. Please check your network and try again.');
//       } else {
//         throw HttpException('Request failed: ${e.toString()}');
//       }
//     }
//   }

//   /// Post data to API
//   static Future<dynamic> postData(String url, Map<String, dynamic> data,
//       [BuildContext? context]) async {
//     return _retryRequest(() => _postDataInternal(url, data, context));
//   }

//   static Future<dynamic> _postDataInternal(
//       String url, Map<String, dynamic> data,
//       [BuildContext? context]) async {
//     try {
//       _logger.i('🚀 [HTTP_POST] Starting POST request to: $url');
//       _logger.d('📦 [HTTP_POST] Request payload: $data');
//       developer.log('🚀 Starting POST request to: $url',
//           name: 'HttpServiceUtils');

//       if (!await checkConnectivity()) {
//         _logger.e('🔌 [HTTP_POST] No internet connection available');
//         throw const HttpException(
//             'No internet connection. Please check your network and try again.');
//       }

//       final headers = <String, String>{
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Connection': 'keep-alive',
//         'Cache-Control': 'no-cache',
//       };

//       final token = await SharedUtils.getString('auth_token');
//       if (token.isNotEmpty) {
//         headers['Authorization'] = 'Bearer $token';
//         _logger.d('🔑 [HTTP_POST] Auth token added to headers');
//         developer.log('🔑 Auth token added', name: 'HttpServiceUtils');
//       } else {
//         _logger.d('⚠️ [HTTP_POST] No auth token available');
//         developer.log('⚠️ No auth token available', name: 'HttpServiceUtils');
//       }

//       _logger.d('📋 [HTTP_POST] Request headers: $headers');

//       final jsonBody = jsonEncode(data);
//       _logger.d('📝 [HTTP_POST] JSON body: $jsonBody');

//       final response = await http
//           .post(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonBody,
//       )
//           .timeout(
//         const Duration(seconds: timeoutDuration),
//         onTimeout: () {
//           _logger.e('⏱️ [HTTP_POST] Request timeout after ${timeoutDuration}s');
//           throw const SocketException(
//               'Connection timeout. Please check your network and try again.');
//         },
//       );

//       _logger.i(
//           '📨 [HTTP_POST] Response received - Status: ${response.statusCode}');
//       _logger.d('📨 [HTTP_POST] Response headers: ${response.headers}');
//       _logger.d('📨 [HTTP_POST] Response body: ${response.body}');
//       developer.log('📨 POST response: ${response.statusCode}',
//           name: 'HttpServiceUtils');

//       return _handleResponse(response, 'POST', url);
//     } on SocketException catch (e) {
//       _logger.e('🔌 [HTTP_POST] Network error: $e');
//       developer.log('🔌 Network error: $e', name: 'HttpServiceUtils', error: e);

//       if (e.toString().contains('timeout') ||
//           e.toString().contains('Connection timeout')) {
//         throw const HttpException(
//             'Connection timeout. Please check your network and try again.');
//       } else {
//         throw const HttpException(
//             'No internet connection. Please check your network.');
//       }
//     } on HttpException catch (e) {
//       _logger.e('🚫 [HTTP_POST] HTTP exception: $e');
//       developer.log('🚫 HTTP exception: $e',
//           name: 'HttpServiceUtils', error: e);
//       rethrow;
//     } on FormatException catch (e) {
//       _logger.e('📝 [HTTP_POST] Format exception: $e');
//       developer.log('📝 Format exception: $e',
//           name: 'HttpServiceUtils', error: e);
//       throw const HttpException(
//           'Invalid response format from server. Please try again.');
//     } catch (e, stackTrace) {
//       _logger.e('💥 [HTTP_POST] Unexpected error: $e');
//       _logger.e('💥 [HTTP_POST] StackTrace: $stackTrace');
//       developer.log('💥 Unexpected POST error: $e',
//           name: 'HttpServiceUtils', error: e, stackTrace: stackTrace);

//       if (e.toString().contains('timeout')) {
//         throw const HttpException(
//             'Connection timeout. Please check your network and try again.');
//       } else {
//         throw HttpException('Request failed: ${e.toString()}');
//       }
//     }
//   }

//   /// Put data to API
//   static Future<dynamic> putData(String url, Map<String, dynamic> data,
//       [BuildContext? context]) async {
//     return _retryRequest(() => _putDataInternal(url, data, context));
//   }

//   static Future<dynamic> _putDataInternal(String url, Map<String, dynamic> data,
//       [BuildContext? context]) async {
//     try {
//       _logger.i('🔄 [HTTP_PUT] Starting PUT request to: $url');
//       _logger.d('📦 [HTTP_PUT] Request payload: $data');
//       developer.log('🔄 Starting PUT request to: $url',
//           name: 'HttpServiceUtils');

//       if (!await checkConnectivity()) {
//         _logger.e('🔌 [HTTP_PUT] No internet connection available');
//         throw const HttpException(
//             'No internet connection. Please check your network and try again.');
//       }

//       final headers = <String, String>{
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Connection': 'keep-alive',
//         'Cache-Control': 'no-cache',
//       };

//       final token = await SharedUtils.getString('auth_token');
//       if (token.isNotEmpty) {
//         headers['Authorization'] = 'Bearer $token';
//         _logger.d('🔑 [HTTP_PUT] Auth token added to headers');
//       }

//       final jsonBody = jsonEncode(data);
//       _logger.d('📝 [HTTP_PUT] JSON body: $jsonBody');

//       final response = await http
//           .put(
//         Uri.parse(url),
//         headers: headers,
//         body: jsonBody,
//       )
//           .timeout(
//         const Duration(seconds: timeoutDuration),
//         onTimeout: () {
//           _logger.e('⏱️ [HTTP_PUT] Request timeout after ${timeoutDuration}s');
//           throw const SocketException(
//               'Connection timeout. Please check your network and try again.');
//         },
//       );

//       _logger.i(
//           '📨 [HTTP_PUT] Response received - Status: ${response.statusCode}');
//       _logger.d('📨 [HTTP_PUT] Response body: ${response.body}');
//       developer.log('📨 PUT response: ${response.statusCode}',
//           name: 'HttpServiceUtils');

//       return _handleResponse(response, 'PUT', url);
//     } on SocketException catch (e) {
//       _logger.e('🔌 [HTTP_PUT] Network error: $e');
//       developer.log('🔌 Network error: $e', name: 'HttpServiceUtils', error: e);

//       if (e.toString().contains('timeout') ||
//           e.toString().contains('Connection timeout')) {
//         throw const HttpException(
//             'Connection timeout. Please check your network and try again.');
//       } else {
//         throw const HttpException(
//             'No internet connection. Please check your network.');
//       }
//     } on HttpException catch (e) {
//       _logger.e('🚫 [HTTP_PUT] HTTP exception: $e');
//       developer.log('🚫 HTTP exception: $e',
//           name: 'HttpServiceUtils', error: e);
//       rethrow;
//     } on FormatException catch (e) {
//       _logger.e('📝 [HTTP_PUT] Format exception: $e');
//       developer.log('📝 Format exception: $e',
//           name: 'HttpServiceUtils', error: e);
//       throw const HttpException(
//           'Invalid response format from server. Please try again.');
//     } catch (e, stackTrace) {
//       _logger.e('💥 [HTTP_PUT] Unexpected error: $e');
//       _logger.e('💥 [HTTP_PUT] StackTrace: $stackTrace');
//       developer.log('💥 Unexpected PUT error: $e',
//           name: 'HttpServiceUtils', error: e, stackTrace: stackTrace);

//       if (e.toString().contains('timeout')) {
//         throw const HttpException(
//             'Connection timeout. Please check your network and try again.');
//       } else {
//         throw HttpException('Request failed: ${e.toString()}');
//       }
//     }
//   }

//   /// Delete data from API
//   static Future<dynamic> deleteData(String url, [BuildContext? context]) async {
//     return _retryRequest(() => _deleteDataInternal(url, context));
//   }

//   static Future<dynamic> _deleteDataInternal(String url,
//       [BuildContext? context]) async {
//     try {
//       _logger.i('🗑️ [HTTP_DELETE] Starting DELETE request to: $url');
//       developer.log('🗑️ Starting DELETE request to: $url',
//           name: 'HttpServiceUtils');

//       if (!await checkConnectivity()) {
//         _logger.e('🔌 [HTTP_DELETE] No internet connection available');
//         throw const HttpException(
//             'No internet connection. Please check your network and try again.');
//       }

//       final headers = <String, String>{
//         'Content-Type': 'application/json',
//         'Accept': 'application/json',
//         'Connection': 'keep-alive',
//         'Cache-Control': 'no-cache',
//       };

//       final token = await SharedUtils.getString('auth_token');
//       if (token.isNotEmpty) {
//         headers['Authorization'] = 'Bearer $token';
//         _logger.d('🔑 [HTTP_DELETE] Auth token added to headers');
//       }

//       final response = await http
//           .delete(
//         Uri.parse(url),
//         headers: headers,
//       )
//           .timeout(
//         const Duration(seconds: timeoutDuration),
//         onTimeout: () {
//           _logger
//               .e('⏱️ [HTTP_DELETE] Request timeout after ${timeoutDuration}s');
//           throw const SocketException(
//               'Connection timeout. Please check your network and try again.');
//         },
//       );

//       _logger.i(
//           '📨 [HTTP_DELETE] Response received - Status: ${response.statusCode}');
//       _logger.d('📨 [HTTP_DELETE] Response body: ${response.body}');
//       developer.log('📨 DELETE response: ${response.statusCode}',
//           name: 'HttpServiceUtils');

//       return _handleResponse(response, 'DELETE', url);
//     } on SocketException catch (e) {
//       _logger.e('🔌 [HTTP_DELETE] Network error: $e');
//       developer.log('🔌 Network error: $e', name: 'HttpServiceUtils', error: e);

//       if (e.toString().contains('timeout') ||
//           e.toString().contains('Connection timeout')) {
//         throw const HttpException(
//             'Connection timeout. Please check your network and try again.');
//       } else {
//         throw const HttpException(
//             'No internet connection. Please check your network.');
//       }
//     } on HttpException catch (e) {
//       _logger.e('🚫 [HTTP_DELETE] HTTP exception: $e');
//       developer.log('🚫 HTTP exception: $e',
//           name: 'HttpServiceUtils', error: e);
//       rethrow;
//     } on FormatException catch (e) {
//       _logger.e('📝 [HTTP_DELETE] Format exception: $e');
//       developer.log('📝 Format exception: $e',
//           name: 'HttpServiceUtils', error: e);
//       throw const HttpException(
//           'Invalid response format from server. Please try again.');
//     } catch (e, stackTrace) {
//       _logger.e('💥 [HTTP_DELETE] Unexpected error: $e');
//       _logger.e('💥 [HTTP_DELETE] StackTrace: $stackTrace');
//       developer.log('💥 Unexpected DELETE error: $e',
//           name: 'HttpServiceUtils', error: e, stackTrace: stackTrace);

//       if (e.toString().contains('timeout')) {
//         throw const HttpException(
//             'Connection timeout. Please check your network and try again.');
//       } else {
//         throw HttpException('Request failed: ${e.toString()}');
//       }
//     }
//   }

//   /// Retry mechanism for network requests
//   static Future<dynamic> _retryRequest(
//       Future<dynamic> Function() requestFunction) async {
//     int retryCount = 0;

//     while (retryCount < maxRetries) {
//       try {
//         return await requestFunction();
//       } on SocketException catch (e) {
//         retryCount++;
//         _logger
//             .w('🔄 [RETRY] Network error, attempt $retryCount/$maxRetries: $e');

//         if (retryCount >= maxRetries) {
//           _logger.e('❌ [RETRY] Max retries reached, giving up');
//           rethrow;
//         }

//         final delaySeconds = (2 * retryCount);
//         _logger.d('⏳ [RETRY] Waiting ${delaySeconds}s before retry...');
//         await Future.delayed(Duration(seconds: delaySeconds));
//       } catch (e) {
//         rethrow;
//       }
//     }

//     throw const HttpException('Max retries exceeded');
//   }

//   /// Handle HTTP response based on status code
//   static dynamic _handleResponse(
//       http.Response response, String method, String url) {
//     final statusCode = response.statusCode;
//     final body = response.body;

//     _logger.d('🔍 [RESPONSE_HANDLER] Processing $method response for $url');
//     _logger.d(
//         '🔍 [RESPONSE_HANDLER] Status: $statusCode, Body length: ${body.length}');
//     developer.log('🔍 Processing $method response: $statusCode',
//         name: 'HttpServiceUtils');

//     switch (statusCode) {
//       case 200:
//       case 201:
//       case 202:
//         _logger.i('✅ [RESPONSE_HANDLER] Success response: $statusCode');
//         developer.log('✅ Success response: $statusCode',
//             name: 'HttpServiceUtils');

//         if (body.isEmpty) {
//           _logger.d('📭 [RESPONSE_HANDLER] Empty response body');
//           return {};
//         }

//         try {
//           final decodedData = jsonDecode(body);
//           _logger.d('📋 [RESPONSE_HANDLER] Decoded JSON response');
//           return decodedData;
//         } catch (e) {
//           _logger.w(
//               '⚠️ [RESPONSE_HANDLER] Failed to decode JSON, returning raw body: $e');
//           developer.log('⚠️ Failed to decode JSON response: $e',
//               name: 'HttpServiceUtils');
//           throw const HttpException(
//               'Invalid response format from server. Please try again.');
//         }

//       case 204:
//         _logger.i('✅ [RESPONSE_HANDLER] No content response: $statusCode');
//         developer.log('✅ No content response: $statusCode',
//             name: 'HttpServiceUtils');
//         return {};

//       case 400:
//         _logger.e('❌ [RESPONSE_HANDLER] Bad request: $statusCode');
//         developer.log('❌ Bad request: $statusCode', name: 'HttpServiceUtils');

//         try {
//           final errorData = jsonDecode(body);
//           final message = errorData['message'] ??
//               errorData['error'] ??
//               'Bad request. Please check your input.';
//           throw HttpException(message);
//         } catch (e) {
//           throw const HttpException('Bad request. Please check your input.');
//         }

//       case 401:
//         _logger.e('🔐 [RESPONSE_HANDLER] Unauthorized: $statusCode');
//         developer.log('🔐 Unauthorized: $statusCode', name: 'HttpServiceUtils');
//         throw const HttpException('Unauthorized. Please login again.');

//       case 403:
//         _logger.e('🚫 [RESPONSE_HANDLER] Forbidden: $statusCode');
//         developer.log('🚫 Forbidden: $statusCode', name: 'HttpServiceUtils');
//         throw const HttpException(
//             'Access forbidden. You don\'t have permission to perform this action.');

//       case 404:
//         _logger.e('🔍 [RESPONSE_HANDLER] Not found: $statusCode');
//         developer.log('🔍 Not found: $statusCode', name: 'HttpServiceUtils');
//         throw const HttpException('Resource not found.');

//       case 422:
//         _logger.e('📝 [RESPONSE_HANDLER] Validation error: $statusCode');
//         developer.log('📝 Validation error: $statusCode',
//             name: 'HttpServiceUtils');

//         try {
//           final errorData = jsonDecode(body);
//           final message = errorData['message'] ?? 'Validation failed';
//           throw HttpException(message);
//         } catch (e) {
//           throw const HttpException(
//               'Validation failed. Please check your input.');
//         }

//       case 500:
//         _logger.e('🔥 [RESPONSE_HANDLER] Server error: $statusCode');
//         developer.log('🔥 Server error: $statusCode', name: 'HttpServiceUtils');
//         throw const HttpException('Server error. Please try again later.');

//       case 502:
//       case 503:
//       case 504:
//         _logger.e('⚡ [RESPONSE_HANDLER] Service unavailable: $statusCode');
//         developer.log('⚡ Service unavailable: $statusCode',
//             name: 'HttpServiceUtils');
//         throw const HttpException(
//             'Service temporarily unavailable. Please try again later.');

//       default:
//         _logger.e('❓ [RESPONSE_HANDLER] Unexpected status code: $statusCode');
//         developer.log('❓ Unexpected status code: $statusCode',
//             name: 'HttpServiceUtils');
//         throw HttpException('Request failed with status code: $statusCode');
//     }
//   }

//   /// Check network connectivity with enhanced reliability
//   static Future<bool> checkConnectivity() async {
//     try {
//       _logger.d('🔍 [CONNECTIVITY] Checking network connectivity');
//       developer.log('🔍 Checking network connectivity',
//           name: 'HttpServiceUtils');

//       final List<Future<InternetAddress>> lookups = [
//         InternetAddress.lookup('google.com').then((result) => result.first),
//         InternetAddress.lookup('cloudflare.com').then((result) => result.first),
//         InternetAddress.lookup('8.8.8.8').then((result) => result.first),
//       ];

//       try {
//         await Future.any(lookups).timeout(const Duration(seconds: 10));

//         _logger.i('🌐 [CONNECTIVITY] Network status: Connected');
//         developer.log('🌐 Network status: Connected', name: 'HttpServiceUtils');
//         return true;
//       } catch (e) {
//         _logger.w('⚠️ [CONNECTIVITY] All connectivity checks failed: $e');
//         developer.log('⚠️ Network status: Disconnected',
//             name: 'HttpServiceUtils');
//         return false;
//       }
//     } catch (e) {
//       _logger.e('❌ [CONNECTIVITY] Network check failed: $e');
//       developer.log('❌ Network check failed: $e',
//           name: 'HttpServiceUtils', error: e);
//       return false;
//     }
//   }
// }
