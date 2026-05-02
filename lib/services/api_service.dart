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
import 'package:path/path.dart' as path;

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  Future<Map<String, dynamic>> putMultipart(
    String endpoint, {
    required Map<String, String> fields,
    List<File>? imageFiles,
    File? videoFile,
    bool requireAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}$endpoint');
    final request = http.MultipartRequest('PUT', uri);

    print("\n╔════════════════════════════════════════════════════════════╗");
    print("║                    MULTIPART REQUEST                        ║");
    print("╠════════════════════════════════════════════════════════════╣");
    print("║ Method: PUT");
    print("║ URL: $uri");
    print("╠────────────────────────────────────────────────────────────╣");

    // Add headers
    request.headers['Accept'] = 'application/json';
    if (requireAuth) {
      final token = SharedPrefService.getAuthToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
        print(
            "║ Headers: Authorization=Bearer ${token.substring(0, token.length > 30 ? 30 : token.length)}...");
      } else {
        print("║ Headers: ⚠️ No auth token found");
      }
    }

    // Add text fields
    request.fields.addAll(fields);
    print("║ Fields:");
    fields.forEach((key, value) {
      // Truncate long values for display
      final displayValue =
          value.length > 100 ? '${value.substring(0, 100)}...' : value;
      print("║   $key: $displayValue");
    });

    // Calculate total size
    int totalBytes = 0;

    // Add images
    if (imageFiles != null && imageFiles.isNotEmpty) {
      print("║ Images: ${imageFiles.length} file(s)");
      for (int i = 0; i < imageFiles.length; i++) {
        final file = imageFiles[i];
        final length = await file.length();
        totalBytes += length;
        final stream = http.ByteStream(file.openRead());
        final multipartFile = http.MultipartFile(
          'images',
          stream,
          length,
          filename: path.basename(file.path),
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);
        print(
            "║   Image $i: ${path.basename(file.path)} (${_formatBytes(length)})");
      }
    } else {
      print("║ Images: No new images");
    }

    // Add video
    if (videoFile != null) {
      final length = await videoFile.length();
      totalBytes += length;
      final stream = http.ByteStream(videoFile.openRead());
      final multipartFile = http.MultipartFile(
        'video',
        stream,
        length,
        filename: path.basename(videoFile.path),
        contentType: MediaType('video', 'mp4'),
      );
      request.files.add(multipartFile);
      print(
          "║ Video: ${path.basename(videoFile.path)} (${_formatBytes(length)})");
    } else {
      print("║ Video: No new video");
    }

    print("║ Total Payload Size: ${_formatBytes(totalBytes)}");
    print("╚════════════════════════════════════════════════════════════╝\n");

    // Send request with timeout
    final stopwatch = Stopwatch()..start();

    try {
      final response = await request.send().timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('Request timeout after 60 seconds');
        },
      );
      stopwatch.stop();

      final responseBody = await response.stream.bytesToString();

      print("\n╔════════════════════════════════════════════════════════════╗");
      print("║                    MULTIPART RESPONSE                       ║");
      print("╠════════════════════════════════════════════════════════════╣");
      print("║ Status Code: ${response.statusCode}");
      print("║ Response Time: ${stopwatch.elapsedMilliseconds}ms");
      print("╠────────────────────────────────────────────────────────────╣");

      // Parse and pretty print response
      try {
        final jsonResponse = json.decode(responseBody);
        print("║ Response Body:");

        // Pretty print JSON
        const encoder = JsonEncoder.withIndent('  ');
        final prettyJson = encoder.convert(jsonResponse);

        // Print response body line by line with proper indentation
        prettyJson.split('\n').forEach((line) {
          if (line.length > 100) {
            print("║ ${line.substring(0, 100)}...");
          } else {
            print("║ $line");
          }
        });

        // Print specific response fields
        if (jsonResponse['success'] != null) {
          print(
              "╠────────────────────────────────────────────────────────────╣");
          print("║ Success: ${jsonResponse['success']}");
        }
        if (jsonResponse['message'] != null) {
          print("║ Message: ${jsonResponse['message']}");
        }
        if (jsonResponse['farmhouse'] != null) {
          final farmhouse = jsonResponse['farmhouse'];
          print("║ Farmhouse ID: ${farmhouse['_id'] ?? 'N/A'}");
          print("║ Farmhouse Name: ${farmhouse['name'] ?? 'N/A'}");
          if (farmhouse['images'] != null) {
            print("║ Images Count: ${(farmhouse['images'] as List).length}");
          }
          if (farmhouse['video'] != null) {
            print("║ Video: ${farmhouse['video']}");
          }
        }
      } catch (e) {
        print("║ Response Body (raw): $responseBody");
      }

      print("╚════════════════════════════════════════════════════════════╝\n");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return json.decode(responseBody);
      } else {
        throw Exception(
            'Failed to update: ${response.statusCode}\nResponse: $responseBody');
      }
    } catch (e) {
      stopwatch.stop();
      print("\n╔════════════════════════════════════════════════════════════╗");
      print("║                    MULTIPART ERROR                          ║");
      print("╠════════════════════════════════════════════════════════════╣");
      print("║ Error: $e");
      print("║ Response Time: ${stopwatch.elapsedMilliseconds}ms");
      print("╚════════════════════════════════════════════════════════════╝\n");
      rethrow;
    }
  }

// Helper method to format bytes
  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024)
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

// Optional: For debugging only - prints request details without actually sending
  Future<void> _debugPrintRequestDetails(
    Map<String, String> fields,
    List<File>? imageFiles,
    File? videoFile,
  ) async {
    print("\n🔍 DEBUG: Request Details (Not Sent)");
    print("Fields:");
    fields.forEach((key, value) {
      print("  $key: $value");
    });

    if (imageFiles != null && imageFiles.isNotEmpty) {
      print("Images:");
      for (var file in imageFiles) {
        final size = await file.length();
        print("  - ${path.basename(file.path)} (${_formatBytes(size)})");
      }
    }

    if (videoFile != null) {
      final size = await videoFile.length();
      print("Video: ${path.basename(videoFile.path)} (${_formatBytes(size)})");
    }
    print("");
  }

// Call this before the actual request for debugging
// await _debugPrintRequestDetails(fields, imageFiles, videoFile);

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
