class AppConstants {
  // App Info
  static const String appName = 'Farmhouse Vendor';
  static const String appVersion = '1.0.0';

  // Shared Preferences Keys
  static const String prefToken = 'auth_token';
  static const String prefVendorId = 'vendor_id';
  static const String prefVendorName = 'vendor_name';
  static const String prefVendorEmail = 'vendor_email';
  static const String prefIsLoggedIn = 'is_logged_in';
  static const String prefThemeMode = 'theme_mode';
  static const String prefFarmhouseId = 'farmhouse_id';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int minNameLength = 3;

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 50;

  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String displayDateFormat = 'dd MMM yyyy';
  static const String displayDateTimeFormat = 'dd MMM yyyy, hh:mm a';

  // Animation Durations
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);

  // Cache Duration
  static const Duration cacheDuration = Duration(minutes: 30);

  // Booking Status
  static const String statusPending = 'pending';
  static const String statusApproved = 'approved';
  static const String statusRejected = 'rejected';
  static const String statusConfirmed = 'confirmed';
  static const String statusCancelled = 'cancelled';
  static const String statusCompleted = 'completed';
  static const String statusActive = 'active';
  static const String statusUpcoming = 'upcoming';
}

// Booking status colors
class StatusColors {
  static const Map<String, int> statusColorMap = {
    AppConstants.statusPending: 0xFFFFC107,
    AppConstants.statusApproved: 0xFF4CAF50,
    AppConstants.statusRejected: 0xFFE53935,
    AppConstants.statusConfirmed: 0xFF2196F3,
    AppConstants.statusCancelled: 0xFF9E9E9E,
    AppConstants.statusCompleted: 0xFF9C27B0,
    AppConstants.statusActive: 0xFF4CAF50,
    AppConstants.statusUpcoming: 0xFFFF9800,
  };
}
