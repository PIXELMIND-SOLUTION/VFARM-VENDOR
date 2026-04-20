import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/shared_pref_service.dart';
import '../models/vendor_model.dart';
import '../models/farmhouse_model.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _error;
  VendorModel? _vendor;
  FarmhouseModel? _farmhouse;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  VendorModel? get vendor => _vendor;
  FarmhouseModel? get farmhouse => _farmhouse;
  bool get isLoggedIn => _isLoggedIn;

  String? _applicationId;
  String? get applicationId => _applicationId;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _isLoggedIn = SharedPrefService.isLoggedIn();
    if (_isLoggedIn) {
      final vendorId = SharedPrefService.getVendorId();
      if (vendorId != null) {
        // Optionally fetch vendor details
        _vendor = VendorModel(
          id: vendorId,
          name: SharedPrefService.getVendorName() ?? '',
          email: SharedPrefService.getVendorEmail() ?? '',
          status: 'approved',
          createdAt: DateTime.now(),
        );
      }
    }
    notifyListeners();
  }

  Future<bool> login(String name, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final request = LoginRequest(name: name, password: password);
      final response = await _apiService.post(
        'api/vendor/login',
        body: request.toJson(),
        requireAuth: false,
      );

      final loginResponse = LoginResponse.fromJson(response);

      if (loginResponse.success && loginResponse.vendor != null) {
        _vendor = loginResponse.vendor;
        _farmhouse = loginResponse.farmhouse;

        // Save to shared preferences
        await SharedPrefService.setLoggedIn(true);
        await SharedPrefService.saveVendorId(_vendor!.id);
        await SharedPrefService.saveVendorName(_vendor!.name);
        await SharedPrefService.saveVendorEmail(_vendor!.email);

        if (_farmhouse != null) {
          await SharedPrefService.saveFarmhouseId(_farmhouse!.id);
        }

        _isLoggedIn = true;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _error = loginResponse.message;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> registerWithImages(RegisterRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.multipartRequest(
        'api/vendor/register',
        request.toFormFields(),
        request.images ?? [],
        'images',
        requireAuth: false,
      );

      final registerResponse = RegisterResponse.fromJson(response);

      if (registerResponse.success) {
        _applicationId = registerResponse.applicationId;
        _setLoading(false);
        return true;
      } else {
        _error = registerResponse.message;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> deleteAccount() async {
    _setLoading(true);
    _clearError();

    try {
      final vendorId = SharedPrefService.getVendorId();
      if (vendorId == null) {
        _error = 'Vendor not found';
        _setLoading(false);
        return false;
      }
      // Call your API endpoint for deleting vendor account
      final response = await _apiService.delete(
        'api/vendor/deletevendor/$vendorId',
        requireAuth: true,
      );

      // Assuming your API returns a response with success flag
      // Adjust this based on your actual API response structure
      if (response['success'] == true || response['status'] == 'success') {
        // Clear all user data from shared preferences
        await SharedPrefService.clearUserData();

        // Clear local state
        _vendor = null;
        _farmhouse = null;
        _isLoggedIn = false;
        _applicationId = null;

        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _error = response['message'] ?? 'Failed to delete account';
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<ApplicationStatusResponse?> getApplicationStatus(
      String applicationId) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get(
        'api/vendor/application/$applicationId/status',
        requireAuth: false,
      );

      final statusResponse = ApplicationStatusResponse.fromJson(response);
      _setLoading(false);
      return statusResponse;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return null;
    }
  }

  Future<void> logout() async {
    await SharedPrefService.clearUserData();
    _vendor = null;
    _farmhouse = null;
    _isLoggedIn = false;
    _clearError();
    notifyListeners();
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
