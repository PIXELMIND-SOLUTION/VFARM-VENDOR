import 'dart:ui';

// class BookingModel {
//   final String id;
//   final UserModel? user;
//   final BookingDetails? bookingDetails;
//   final double slotPrice;
//   final double cleaningFee;
//   final double serviceFee;
//   final double totalAmount;
//   final double advancePayment;
//   final double remainingAmount;
//   final String paymentStatus;
//   final String status;
//   final DateTime createdAt;
//   final DateTime updatedAt;

//   BookingModel({
//     required this.id,
//     this.user,
//     this.bookingDetails,
//     required this.slotPrice,
//     required this.cleaningFee,
//     required this.serviceFee,
//     required this.totalAmount,
//     required this.advancePayment,
//     required this.remainingAmount,
//     required this.paymentStatus,
//     required this.status,
//     required this.createdAt,
//     required this.updatedAt,
//   });

//   factory BookingModel.fromJson(Map<String, dynamic> json) {
//     return BookingModel(
//       id: json['_id'] ?? '',
//       user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
//       bookingDetails: json['bookingDetails'] != null
//           ? BookingDetails.fromJson(json['bookingDetails'])
//           : null,
//       slotPrice: (json['slotPrice'] ?? 0).toDouble(),
//       cleaningFee: (json['cleaningFee'] ?? 0).toDouble(),
//       serviceFee: (json['serviceFee'] ?? 0).toDouble(),
//       totalAmount: (json['totalAmount'] ?? 0).toDouble(),
//       advancePayment: (json['advancePayment'] ?? 0).toDouble(),
//       remainingAmount: (json['remainingAmount'] ?? 0).toDouble(),
//       paymentStatus: json['paymentStatus'] ?? 'pending',
//       status: json['status'] ?? 'pending',
//       createdAt:
//           DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
//       updatedAt:
//           DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
//     );
//   }

//   bool get isConfirmed => status == 'confirmed';
//   bool get isPending => status == 'pending';
//   bool get isCancelled => status == 'cancelled';
//   bool get isCompleted => status == 'completed';
//   bool get isUpcoming => status == 'upcoming';
//   bool get isActive => status == 'active';

//   bool get isPaymentCompleted => paymentStatus == 'completed';
//   bool get isPaymentPending => paymentStatus == 'pending';

//   String get statusText {
//     switch (status) {
//       case 'pending':
//         return 'Pending';
//       case 'confirmed':
//         return 'Confirmed';
//       case 'cancelled':
//         return 'Cancelled';
//       case 'completed':
//         return 'Completed';
//       case 'upcoming':
//         return 'Upcoming';
//       case 'active':
//         return 'Active';
//       default:
//         return status;
//     }
//   }

//   Color get statusColor {
//     switch (status) {
//       case 'pending':
//         return const Color(0xFFFFC107);
//       case 'confirmed':
//         return const Color(0xFF2196F3);
//       case 'cancelled':
//         return const Color(0xFFE53935);
//       case 'completed':
//         return const Color(0xFF4CAF50);
//       case 'upcoming':
//         return const Color(0xFFFF9800);
//       case 'active':
//         return const Color(0xFF4CAF50);
//       default:
//         return const Color(0xFF9E9E9E);
//     }
//   }
// }

// class BookingDetails {
//   final DateTime date;
//   final String label;
//   final String timing;
//   final DateTime checkIn;
//   final DateTime checkOut;

//   BookingDetails({
//     required this.date,
//     required this.label,
//     required this.timing,
//     required this.checkIn,
//     required this.checkOut,
//   });

//   factory BookingDetails.fromJson(Map<String, dynamic> json) {
//     return BookingDetails(
//       date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
//       label: json['label'] ?? '',
//       timing: json['timing'] ?? '',
//       checkIn:
//           DateTime.parse(json['checkIn'] ?? DateTime.now().toIso8601String()),
//       checkOut:
//           DateTime.parse(json['checkOut'] ?? DateTime.now().toIso8601String()),
//     );
//   }
// }

import 'dart:ui';

class BookingModel {
  final String id;
  final UserModel? user;
  final BookingDetails? bookingDetails;

  final double slotPrice;
  final double cleaningFee;
  final double serviceFee;
  final double totalAmount;
  final double advancePayment;
  final double remainingAmount;

  final String paymentStatus;
  final String status;
  final String? originalStatus;

  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    this.user,
    this.bookingDetails,
    required this.slotPrice,
    required this.cleaningFee,
    required this.serviceFee,
    required this.totalAmount,
    required this.advancePayment,
    required this.remainingAmount,
    required this.paymentStatus,
    required this.status,
    this.originalStatus,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'] ?? '',
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
      bookingDetails: json['bookingDetails'] != null
          ? BookingDetails.fromJson(json['bookingDetails'])
          : null,
      slotPrice: (json['slotPrice'] ?? 0).toDouble(),
      cleaningFee: (json['cleaningFee'] ?? 0).toDouble(),
      serviceFee: (json['serviceFee'] ?? 0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      advancePayment: (json['advancePayment'] ?? 0).toDouble(),
      remainingAmount: (json['remainingAmount'] ?? 0).toDouble(),
      paymentStatus: (json['paymentStatus'] ?? 'pending').toLowerCase(),
      status: (json['status'] ?? 'pending').toLowerCase(),
      originalStatus: json['originalStatus'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  // ---------------- STATUS FLAGS ----------------

  bool get isConfirmed => status == 'confirmed';
  bool get isPending => status == 'pending';
  bool get isCancelled => status == 'cancelled';
  bool get isCompleted => status == 'completed';
  bool get isUpcoming => status == 'upcoming';
  bool get isActive => status == 'active';

  // ---------------- PAYMENT FLAGS ----------------

  bool get isPaymentPaid => paymentStatus == 'paid';
  bool get isPaymentPartial => paymentStatus == 'partial';
  bool get isPaymentPending => paymentStatus == 'pending';

  // ---------------- DISPLAY ----------------

  String get statusText {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'confirmed':
        return 'Confirmed';
      case 'cancelled':
        return 'Cancelled';
      case 'completed':
        return 'Completed';
      case 'upcoming':
        return 'Upcoming';
      case 'active':
        return 'Active';
      default:
        return status;
    }
  }

  String get paymentText {
    switch (paymentStatus) {
      case 'paid':
        return 'Paid';
      case 'partial':
        return 'Partially Paid';
      case 'pending':
        return 'Pending';
      default:
        return paymentStatus;
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending':
        return const Color(0xFFFFC107);
      case 'confirmed':
        return const Color(0xFF2196F3);
      case 'cancelled':
        return const Color(0xFFE53935);
      case 'completed':
        return const Color(0xFF4CAF50);
      case 'upcoming':
        return const Color(0xFFFF9800);
      case 'active':
        return const Color(0xFF4CAF50);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  Color get paymentColor {
    switch (paymentStatus) {
      case 'paid':
        return const Color(0xFF4CAF50);
      case 'partial':
        return const Color(0xFFFF9800);
      case 'pending':
        return const Color(0xFFE53935);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}

class BookingDetails {
  final DateTime date;
  final String label;
  final String timing;
  final DateTime checkIn;
  final DateTime checkOut;

  BookingDetails({
    required this.date,
    required this.label,
    required this.timing,
    required this.checkIn,
    required this.checkOut,
  });

  factory BookingDetails.fromJson(Map<String, dynamic> json) {
    return BookingDetails(
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      label: json['label'] ?? '',
      timing: json['timing'] ?? '',
      checkIn:
          DateTime.parse(json['checkIn'] ?? DateTime.now().toIso8601String()),
      checkOut:
          DateTime.parse(json['checkOut'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profileImage;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? json['phoneNumber'],
      profileImage: json['profileImage'],
    );
  }
}
