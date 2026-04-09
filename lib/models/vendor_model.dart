import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:vendor_app/models/farmhouse_model.dart';

class VendorModel {
  final String id;
  final String name;
  final String email;
  final String? password;
  final String? farmhouseId;
  final String? applicationId;
  final String status;
  final DateTime createdAt;
  final DateTime? reviewedAt;
  final String? adminNotes;
  final String? rejectedReason;
  final VendorCredentials? credentials;

  VendorModel({
    required this.id,
    required this.name,
    required this.email,
    this.password,
    this.farmhouseId,
    this.applicationId,
    required this.status,
    required this.createdAt,
    this.reviewedAt,
    this.adminNotes,
    this.rejectedReason,
    this.credentials,
  });

  factory VendorModel.fromJson(Map<String, dynamic> json) {
    return VendorModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '', // optional
      password: json['password'],
      farmhouseId: json['farmhouseId'],
      applicationId: json['applicationId'],
      status: json['status'] ?? 'approved', // 👈 better default
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'])
          : null,
      adminNotes: json['adminNotes'],
      rejectedReason: json['rejectedReason'],
      credentials: json['credentials'] != null
          ? VendorCredentials.fromJson(json['credentials'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'password': password,
      'farmhouseId': farmhouseId,
      'applicationId': applicationId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'reviewedAt': reviewedAt?.toIso8601String(),
      'adminNotes': adminNotes,
      'rejectedReason': rejectedReason,
      'credentials': credentials?.toJson(),
    };
  }

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pending Review';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending':
        return const Color(0xFFFFC107);
      case 'approved':
        return const Color(0xFF4CAF50);
      case 'rejected':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}

class VendorCredentials {
  final String vendorName;
  final String password;

  VendorCredentials({
    required this.vendorName,
    required this.password,
  });

  factory VendorCredentials.fromJson(Map<String, dynamic> json) {
    return VendorCredentials(
      vendorName: json['vendorName'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'vendorName': vendorName,
      'password': password,
    };
  }
}

class LoginRequest {
  final String name;
  final String password;

  LoginRequest({
    required this.name,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'password': password,
    };
  }
}

class LoginResponse {
  final bool success;
  final String message;
  final VendorModel? vendor;
  final FarmhouseModel? farmhouse;

  LoginResponse({
    required this.success,
    required this.message,
    this.vendor,
    this.farmhouse,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      vendor:
          json['vendor'] != null ? VendorModel.fromJson(json['vendor']) : null,
      farmhouse: json['farmhouse'] != null
          ? FarmhouseModel.fromJson(json['farmhouse'])
          : null,
    );
  }
}

// class RegisterRequest {
//   final String name;
//   final String email;
//   final String address;
//   final double lat;
//   final double lng;
//   final double price;
//   final String? description;
//   final List<String>? amenities;
//   final String? bookingFor;
//   final double? rating;
//   final String? feedbackSummary;
//   final List<TimePrice>? timePrices;
//   final List<String>? images;

//   RegisterRequest({
//     required this.name,
//     required this.email,
//     required this.address,
//     required this.lat,
//     required this.lng,
//     required this.price,
//     this.description,
//     this.amenities,
//     this.bookingFor,
//     this.rating,
//     this.feedbackSummary,
//     this.timePrices,
//     this.images,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'email': email,
//       'address': address,
//       'lat': lat,
//       'lng': lng,
//       'price': price,
//       'description': description,
//       'amenities': amenities,
//       'bookingFor': bookingFor,
//       'rating': rating,
//       'feedbackSummary': feedbackSummary,
//       'timePrices': timePrices?.map((e) => e.toJson()).toList(),
//       'images': images,
//     };
//   }
// }

class RegisterRequest {
  final String name;
  final String email;
  final String address;
  final double lat;
  final double lng;
  final double price;
  final String? description;
  final List<String>? amenities;
  final String? bookingFor;
  final double? rating;
  final String? feedbackSummary;
  final List<TimePrice>? timePrices;
  final List<File>? images;

  RegisterRequest({
    required this.name,
    required this.email,
    required this.address,
    required this.lat,
    required this.lng,
    required this.price,
    this.description,
    this.amenities,
    this.bookingFor,
    this.rating,
    this.feedbackSummary,
    this.timePrices,
    this.images,
  });

  // Convert to form fields (without images)
  Map<String, String> toFormFields() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'lat': lat.toString(),
      'lng': lng.toString(),
      'price': price.toString(),
      if (description != null) 'description': description!,
      if (amenities != null) 'amenities': amenities!.join(','),
      if (bookingFor != null) 'bookingFor': bookingFor!,
      if (rating != null) 'rating': rating!.toString(),
      if (feedbackSummary != null) 'feedbackSummary': feedbackSummary!,
      if (timePrices != null)
        'timePrices': jsonEncode(timePrices!.map((e) => e.toJson()).toList()),
    };
  }

  // For JSON (without files)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'address': address,
      'lat': lat,
      'lng': lng,
      'price': price,
      'description': description,
      'amenities': amenities,
      'bookingFor': bookingFor,
      'rating': rating,
      'feedbackSummary': feedbackSummary,
      'timePrices': timePrices?.map((e) => e.toJson()).toList(),
    };
  }
}

class RegisterResponse {
  final bool success;
  final String message;
  final String? applicationId;
  final String? status;

  RegisterResponse({
    required this.success,
    required this.message,
    this.applicationId,
    this.status,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      applicationId: json['applicationId'],
      status: json['status'],
    );
  }
}

class ApplicationStatusResponse {
  final bool success;
  final String applicationId;
  final String status;
  final String farmhouseName;
  final DateTime submittedAt;
  final DateTime? reviewedAt;
  final String? adminNotes;
  final String? rejectedReason;
  final VendorCredentials? credentials;

  ApplicationStatusResponse({
    required this.success,
    required this.applicationId,
    required this.status,
    required this.farmhouseName,
    required this.submittedAt,
    this.reviewedAt,
    this.adminNotes,
    this.rejectedReason,
    this.credentials,
  });

  factory ApplicationStatusResponse.fromJson(Map<String, dynamic> json) {
    return ApplicationStatusResponse(
      success: json['success'] ?? false,
      applicationId: json['applicationId'] ?? '',
      status: json['status'] ?? 'pending',
      farmhouseName: json['farmhouseName'] ?? '',
      submittedAt: DateTime.parse(
          json['submittedAt'] ?? DateTime.now().toIso8601String()),
      reviewedAt: json['reviewedAt'] != null
          ? DateTime.parse(json['reviewedAt'])
          : null,
      adminNotes: json['adminNotes'],
      rejectedReason: json['rejectedReason'],
      credentials: json['credentials'] != null
          ? VendorCredentials.fromJson(json['credentials'])
          : null,
    );
  }
}
