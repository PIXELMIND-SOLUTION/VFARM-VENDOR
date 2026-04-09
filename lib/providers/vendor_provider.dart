import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/shared_pref_service.dart';
import '../models/farmhouse_model.dart';
import '../models/booking_model.dart';
import '../models/dashboard_model.dart';

class VendorProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _error;
  FarmhouseModel? _farmhouse;
  List<BookingModel> _bookings = [];
  DashboardModel? _dashboard;

  bool get isLoading => _isLoading;
  String? get error => _error;
  FarmhouseModel? get farmhouse => _farmhouse;
  List<BookingModel> get bookings => _bookings;
  DashboardModel? get dashboard => _dashboard;

  Future<DashboardModel?> getDashboard() async {
    _setLoading(true);
    _clearError();

    try {
      final vendorId = SharedPrefService.getVendorId();
      if (vendorId == null) {
        _error = 'Vendor not found';
        _setLoading(false);
        return null;
      }

      final response = await _apiService.get(
        'api/vendor/dashboard/$vendorId',
        requireAuth: true,
      );

      final dashboardData = DashboardModel.fromJson(response);
      _dashboard = dashboardData;
      _setLoading(false);
      return dashboardData;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return null;
    }
  }

  Future<FarmhouseModel?> getFarmhouse() async {
    _setLoading(true);
    _clearError();

    try {
      final vendorId = SharedPrefService.getVendorId();
      if (vendorId == null) {
        _error = 'Vendor not found';
        _setLoading(false);
        return null;
      }

      print("🟢 Fetching farmhouse for vendorId: $vendorId");

      final response = await _apiService.get(
        'api/vendor/farmhouse/$vendorId',
        requireAuth: true,
      );

      print("🟢 API Response: $response");

      if (response['success'] == true && response['farmhouse'] != null) {
        final farmhouseData = FarmhouseModel.fromJson(response['farmhouse']);
        print("🟢 Parsed farmhouse: ${farmhouseData.name}");

        _farmhouse = farmhouseData;
        _setLoading(false);
        notifyListeners(); // Important!
        return farmhouseData;
      } else {
        print("🔴 Response does not contain farmhouse data");
        _error = 'Invalid response format';
        _setLoading(false);
        notifyListeners(); // Notify even on error
        return null;
      }
    } catch (e) {
      print("🔴 Error in getFarmhouse: $e");
      _error = e.toString();
      _setLoading(false);
      notifyListeners(); // Notify even on error
      return null;
    }
  }

  Future<bool> updateFarmhouse(Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    try {
      final vendorId = SharedPrefService.getVendorId();
      if (vendorId == null) {
        _error = 'Vendor not found';
        _setLoading(false);
        return false;
      }

      final response = await _apiService.put(
        'api/vendor/farmhouse/$vendorId',
        body: data,
        requireAuth: true,
      );

      if (response['success'] == true) {
        await getFarmhouse(); // Refresh farmhouse data
        _setLoading(false);
        return true;
      } else {
        _error = response['message'] ?? 'Update failed';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<List<BookingModel>> getBookings({String? status}) async {
    _setLoading(true);
    _clearError();

    try {
      final vendorId = SharedPrefService.getVendorId();
      if (vendorId == null) {
        _error = 'Vendor not found';
        _setLoading(false);
        return [];
      }

      String endpoint = 'api/vendor/bookings/$vendorId';
      if (status != null && status != 'all') {
        endpoint = '$endpoint?status=$status';
      }

      final response = await _apiService.get(
        endpoint,
        requireAuth: true,
      );

      final bookingsList = (response['bookings'] as List?)
              ?.map((e) => BookingModel.fromJson(e))
              .toList() ??
          [];

      _bookings = bookingsList;
      _setLoading(false);
      return bookingsList;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return [];
    }
  }

  Future<bool> toggleFarmhouseActive({
    required bool active,
    DateTime? date,
    String? reason,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final vendorId = SharedPrefService.getVendorId();
      if (vendorId == null) {
        _error = 'Vendor not found';
        _setLoading(false);
        return false;
      }

      final body = {
        'active': active,
        if (date != null) 'date': date.toIso8601String().split('T')[0],
        if (reason != null) 'reason': reason,
      };

      final response = await _apiService.put(
        'api/vendor/farmhouse/$vendorId/toggle-active',
        body: body,
        requireAuth: true,
      );

      if (response['success'] == true) {
        await getFarmhouse(); // Refresh farmhouse data
        _setLoading(false);
        return true;
      } else {
        _error = response['message'] ?? 'Operation failed';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> toggleSlotActive({
    required String slotId,
    required bool isActive,
    required DateTime date,
    String? reason,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final vendorId = SharedPrefService.getVendorId();
      if (vendorId == null) {
        _error = 'Vendor not found';
        _setLoading(false);
        return false;
      }

      final body = {
        'isActive': isActive,
        'date': date.toIso8601String().split('T')[0],
        if (reason != null) 'reason': reason,
      };

      final response = await _apiService.put(
        'api/vendor/farmhouse/$vendorId/slot/$slotId/toggle',
        body: body,
        requireAuth: true,
      );

      if (response['success'] == true) {
        await getFarmhouse(); // Refresh farmhouse data
        _setLoading(false);
        return true;
      } else {
        _error = response['message'] ?? 'Operation failed';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
