import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF388E3C);
  static const Color primaryLight = Color(0xFF81C784);

  // Secondary Colors
  static const Color secondary = Color(0xFFFF9800);
  static const Color secondaryDark = Color(0xFFF57C00);
  static const Color secondaryLight = Color(0xFFFFB74D);

  // Accent Colors
  static const Color accent = Color(0xFF9C27B0);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color darkGrey = Color(0xFF616161);
  static const Color lightGrey = Color(0xFFF5F5F5);

  // Text Colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Background Colors
  static const Color background = Color(0xFFF8F9FA);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color scaffoldBackground = Color(0xFFF8F9FA);

  // Status Colors
  static const Color pending = Color(0xFFFFC107);
  static const Color approved = Color(0xFF4CAF50);
  static const Color rejected = Color(0xFFE53935);
  static const Color active = Color(0xFF2196F3);
  static const Color completed = Color(0xFF9C27B0);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF4CAF50),
    Color(0xFF388E3C),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFFF9800),
    Color(0xFFF57C00),
  ];
}

// Helper extension for responsive colors
extension ColorExtension on Color {
  MaterialColor toMaterialColor() {
    final shades = <int, Color>{
      50: withOpacity(0.1),
      100: withOpacity(0.2),
      200: withOpacity(0.3),
      300: withOpacity(0.4),
      400: withOpacity(0.5),
      500: this,
      600: withOpacity(0.7),
      700: withOpacity(0.8),
      800: withOpacity(0.9),
      900: withOpacity(1.0),
    };
    return MaterialColor(value, shades);
  }

  Color withOpacity(double opacity) {
    return Color.fromRGBO(red, green, blue, opacity);
  }

  int get red => (this.value >> 16) & 0xFF;
  int get green => (this.value >> 8) & 0xFF;
  int get blue => this.value & 0xFF;
}
