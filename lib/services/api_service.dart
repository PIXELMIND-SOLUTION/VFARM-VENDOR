// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import '../constants/api_constants.dart';
// import '../services/shared_pref_service.dart';

// class ApiService {
//   static final ApiService _instance = ApiService._internal();
//   factory ApiService() => _instance;
//   ApiService._internal();

//   // GET request
//   Future<Map<String, dynamic>> get(
//     String endpoint, {
//     Map<String, String>? params,
//     Map<String, String>? headers,
//     bool requireAuth = true,
//   }) async {
//     try {
//       final token = requireAuth ? SharedPrefService.getAuthToken() : null;
//       final url = ApiConstants.getUrl(endpoint, params: params);

//       final response = await http
//           .get(
//             Uri.parse(url),
//             headers: ApiConstants.getHeaders(token: token),
//           )
//           .timeout(
//             const Duration(seconds: ApiConstants.connectionTimeout ~/ 1000),
//           );

//       return _handleResponse(response);
//     } catch (e) {
//       return _handleError(e);
//     }
//   }

//   // POST request
//   Future<Map<String, dynamic>> post(
//     String endpoint, {
//     Map<String, dynamic>? body,
//     Map<String, String>? headers,
//     bool requireAuth = true,
//   }) async {
//     try {
//       final token = requireAuth ? SharedPrefService.getAuthToken() : null;
//       final url = ApiConstants.getUrl(endpoint);

//       final response = await http
//           .post(
//             Uri.parse(url),
//             headers: ApiConstants.getHeaders(token: token),
//             body: jsonEncode(body),
//           )
//           .timeout(
//             const Duration(seconds: ApiConstants.connectionTimeout ~/ 1000),
//           );

//       return _handleResponse(response);
//     } catch (e) {
//       return _handleError(e);
//     }
//   }

//   // PUT request
//   Future<Map<String, dynamic>> put(
//     String endpoint, {
//     Map<String, dynamic>? body,
//     Map<String, String>? headers,
//     bool requireAuth = true,
//     String? vendorId,
//   }) async {
//     try {
//       final token = requireAuth ? SharedPrefService.getAuthToken() : null;
//       final url = ApiConstants.getUrl(endpoint, vendorId: vendorId);

//       final response = await http
//           .put(
//             Uri.parse(url),
//             headers: ApiConstants.getHeaders(token: token),
//             body: jsonEncode(body),
//           )
//           .timeout(
//             const Duration(seconds: ApiConstants.connectionTimeout ~/ 1000),
//           );

//       return _handleResponse(response);
//     } catch (e) {
//       return _handleError(e);
//     }
//   }

//   // DELETE request
//   Future<Map<String, dynamic>> delete(
//     String endpoint, {
//     Map<String, String>? headers,
//     bool requireAuth = true,
//   }) async {
//     try {
//       final token = requireAuth ? SharedPrefService.getAuthToken() : null;
//       final url = ApiConstants.getUrl(endpoint);

//       final response = await http
//           .delete(
//             Uri.parse(url),
//             headers: ApiConstants.getHeaders(token: token),
//           )
//           .timeout(
//             const Duration(seconds: ApiConstants.connectionTimeout ~/ 1000),
//           );

//       return _handleResponse(response);
//     } catch (e) {
//       return _handleError(e);
//     }
//   }

//   // Multipart request for file upload
//   Future<Map<String, dynamic>> multipart(
//     String endpoint,
//     Map<String, String> fields,
//     List<http.MultipartFile> files, {
//     bool requireAuth = true,
//   }) async {
//     try {
//       final token = requireAuth ? SharedPrefService.getAuthToken() : null;
//       final url = ApiConstants.getUrl(endpoint);

//       final request = http.MultipartRequest('POST', Uri.parse(url));
//       request.headers.addAll(ApiConstants.getHeaders(token: token));
//       request.fields.addAll(fields);
//       request.files.addAll(files);

//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       return _handleResponse(response);
//     } catch (e) {
//       return _handleError(e);
//     }
//   }

//   // Handle response
//   Map<String, dynamic> _handleResponse(http.Response response) {
//     print("RESPONSE BODY: ${response.body}");
//     print("RESPONSE STATUS: ${response.statusCode}");

//     final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       return decodedResponse;
//     } else {
//       throw ApiException(
//         message: decodedResponse['message'] ?? 'Something went wrong',
//         statusCode: response.statusCode,
//         data: decodedResponse,
//       );
//     }
//   }

//   // Handle error
//   Map<String, dynamic> _handleError(dynamic error) {
//     if (error is ApiException) {
//       throw error;
//     } else if (error is http.ClientException) {
//       throw ApiException(
//         message: 'Network error. Please check your internet connection.',
//         statusCode: 0,
//       );
//     } else {
//       throw ApiException(
//         message: error.toString(),
//         statusCode: 500,
//       );
//     }
//   }
// }

// // Custom exception class
// class ApiException implements Exception {
//   final String message;
//   final int statusCode;
//   final Map<String, dynamic>? data;

//   ApiException({
//     required this.message,
//     required this.statusCode,
//     this.data,
//   });

//   @override
//   String toString() => message;
// }

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../constants/api_constants.dart';
import '../services/shared_pref_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? params,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    try {
      final token = requireAuth ? SharedPrefService.getAuthToken() : null;
      final url = ApiConstants.getUrl(endpoint, params: params);

      final response = await http
          .get(
            Uri.parse(url),
            headers: ApiConstants.getHeaders(token: token),
          )
          .timeout(
            const Duration(seconds: ApiConstants.connectionTimeout ~/ 1000),
          );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    try {
      final token = requireAuth ? SharedPrefService.getAuthToken() : null;
      final url = ApiConstants.getUrl(endpoint);

      final response = await http
          .post(
            Uri.parse(url),
            headers: ApiConstants.getHeaders(token: token),
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: ApiConstants.connectionTimeout ~/ 1000),
          );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requireAuth = true,
    String? vendorId,
  }) async {
    try {
      final token = requireAuth ? SharedPrefService.getAuthToken() : null;
      final url = ApiConstants.getUrl(endpoint, vendorId: vendorId);

      final response = await http
          .put(
            Uri.parse(url),
            headers: ApiConstants.getHeaders(token: token),
            body: jsonEncode(body),
          )
          .timeout(
            const Duration(seconds: ApiConstants.connectionTimeout ~/ 1000),
          );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, String>? headers,
    bool requireAuth = true,
  }) async {
    try {
      final token = requireAuth ? SharedPrefService.getAuthToken() : null;
      final url = ApiConstants.getUrl(endpoint);

      final response = await http
          .delete(
            Uri.parse(url),
            headers: ApiConstants.getHeaders(token: token),
          )
          .timeout(
            const Duration(seconds: ApiConstants.connectionTimeout ~/ 1000),
          );

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Multipart request for file upload (takes List<File>)
  Future<Map<String, dynamic>> multipartRequest(
    String endpoint,
    Map<String, dynamic> fields,
    List<File> files,
    String fileKey, {
    bool requireAuth = true,
  }) async {
    try {
      final token = requireAuth ? SharedPrefService.getAuthToken() : null;
      final url = ApiConstants.getUrl(endpoint);

      print("📤 Making multipart request to: $url");
      print("📤 Fields: $fields");
      print("📤 Number of files: ${files.length}");

      final request = http.MultipartRequest('POST', Uri.parse(url));

      // Add headers
      request.headers.addAll(ApiConstants.getHeaders(token: token));

      // Add text fields
      fields.forEach((key, value) {
        if (value != null) {
          request.fields[key] = value.toString();
        }
      });

      // Add files
      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final multipartFile = await http.MultipartFile.fromPath(
          fileKey, // Use the same key for all files (backend will handle as array)
          file.path,
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
        print("📤 Added file ${i + 1}: ${file.path}");
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📥 Response status: ${response.statusCode}");
      print("📥 Response body: ${response.body}");

      return _handleResponse(response);
    } catch (e) {
      print("❌ Multipart request error: $e");
      return _handleError(e);
    }
  }

  // Legacy multipart method (kept for backward compatibility)
  Future<Map<String, dynamic>> multipart(
    String endpoint,
    Map<String, String> fields,
    List<http.MultipartFile> files, {
    bool requireAuth = true,
  }) async {
    try {
      final token = requireAuth ? SharedPrefService.getAuthToken() : null;
      final url = ApiConstants.getUrl(endpoint);

      final request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers.addAll(ApiConstants.getHeaders(token: token));
      request.fields.addAll(fields);
      request.files.addAll(files);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Handle response
  Map<String, dynamic> _handleResponse(http.Response response) {
    print("RESPONSE BODY: ${response.body}");
    print("RESPONSE STATUS: ${response.statusCode}");

    final Map<String, dynamic> decodedResponse = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decodedResponse;
    } else {
      throw ApiException(
        message: decodedResponse['message'] ?? 'Something went wrong',
        statusCode: response.statusCode,
        data: decodedResponse,
      );
    }
  }

  // Handle error
  Map<String, dynamic> _handleError(dynamic error) {
    if (error is ApiException) {
      throw error;
    } else if (error is http.ClientException) {
      throw ApiException(
        message: 'Network error. Please check your internet connection.',
        statusCode: 0,
      );
    } else {
      throw ApiException(
        message: error.toString(),
        statusCode: 500,
      );
    }
  }
}

// Custom exception class
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, dynamic>? data;

  ApiException({
    required this.message,
    required this.statusCode,
    this.data,
  });

  @override
  String toString() => message;
}
