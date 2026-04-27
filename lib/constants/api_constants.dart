import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  // Base URL - Load from .env file
  static String get baseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://backend.vfarmstays.com/';

  // API Endpoints
  static const String vendorLogin = '/api/vendor/login';
  static const String vendorRegister = '/api/vendor/register';
  static const String applicationStatus = '/api/vendor/application';
  static const String vendorDashboard = '/api/vendor/dashboard';
  static const String vendorFarmhouse = '/api/vendor/farmhouse';
  static const String vendorBookings = '/api/vendor/bookings';
  static const String vendorEarnings = '/api/vendor/earnings';
  static const String toggleFarmhouseActive =
      '/api/vendor/farmhouse/toggle-active';
  static const String inactiveDates = '/api/vendor/farmhouse/inactive-dates';
  static const String toggleSlot = '/api/vendor/farmhouse/slot';
  static const String privacyPolicyUrl =
      'https://v-farm-house-owner-policies.onrender.com/privacy-policy';
  static const String termsAndConditionsUrl =
      'https://v-farm-house-owner-policies.onrender.com/terms-and-conditions';
  static const String about = 'https://varahiautomotives.com/';

  // Helper method to build URL
  static String getUrl(String endpoint,
      {Map<String, String>? params, String? vendorId}) {
    var url = '$baseUrl$endpoint';

    if (vendorId != null) {
      url = url.replaceFirst(':vendorId', vendorId);
    }

    if (params != null && params.isNotEmpty) {
      final queryString = params.entries
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
          .join('&');
      url = '$url?$queryString';
    }

    return url;
  }

  // Headers
  static Map<String, String> getHeaders({String? token}) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}

// Status codes
class StatusCode {
  static const int success = 200;
  static const int created = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int serverError = 500;
}
