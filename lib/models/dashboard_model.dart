class DashboardModel {
  final VendorInfo vendor;
  final FarmhouseInfo farmhouse;
  final DashboardStatistics statistics;
  final List<RecentBooking> recentBookings;
  final List<MonthlyRevenue> monthlyRevenue;

  DashboardModel({
    required this.vendor,
    required this.farmhouse,
    required this.statistics,
    required this.recentBookings,
    required this.monthlyRevenue,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      vendor: VendorInfo.fromJson(json['vendor'] ?? {}),
      farmhouse: FarmhouseInfo.fromJson(json['farmhouse'] ?? {}),
      statistics: DashboardStatistics.fromJson(json['statistics'] ?? {}),
      recentBookings: (json['recentBookings'] as List?)
              ?.map((e) => RecentBooking.fromJson(e))
              .toList() ??
          [],
      monthlyRevenue: (json['monthlyRevenue'] as List?)
              ?.map((e) => MonthlyRevenue.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class VendorInfo {
  final String id;
  final String name;
  final String email;
  final String? farmhouseId;

  VendorInfo({
    required this.id,
    required this.name,
    required this.email,
    this.farmhouseId,
  });

  factory VendorInfo.fromJson(Map<String, dynamic> json) {
    return VendorInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      farmhouseId: json['farmhouseId'],
    );
  }
}

class FarmhouseInfo {
  final String id;
  final String name;
  final String address;
  final double price;
  final double rating;
  final bool active;
  final List<String> images;
  final List<String> amenities;

  FarmhouseInfo({
    required this.id,
    required this.name,
    required this.address,
    required this.price,
    required this.rating,
    required this.active,
    required this.images,
    required this.amenities,
  });

  factory FarmhouseInfo.fromJson(Map<String, dynamic> json) {
    return FarmhouseInfo(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      active: json['active'] ?? true,
      images: List<String>.from(json['images'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
    );
  }
}

class DashboardStatistics {
  final int totalBookings;
  final double totalRevenue;
  final int todayBookings;
  final int upcomingBookings;
  final int completedBookings;
  final int cancelledBookings;

  DashboardStatistics({
    required this.totalBookings,
    required this.totalRevenue,
    required this.todayBookings,
    required this.upcomingBookings,
    required this.completedBookings,
    required this.cancelledBookings,
  });

  factory DashboardStatistics.fromJson(Map<String, dynamic> json) {
    return DashboardStatistics(
      totalBookings: json['totalBookings'] ?? 0,
      totalRevenue: (json['totalRevenue'] ?? 0).toDouble(),
      todayBookings: json['todayBookings'] ?? 0,
      upcomingBookings: json['upcomingBookings'] ?? 0,
      completedBookings: json['completedBookings'] ?? 0,
      cancelledBookings: json['cancelledBookings'] ?? 0,
    );
  }
}

class RecentBooking {
  final String id;
  final String user;
  final String userEmail;
  final DateTime date;
  final DateTime checkIn;
  final String label;
  final double totalAmount;
  final String status;
  final String paymentStatus;

  RecentBooking({
    required this.id,
    required this.user,
    required this.userEmail,
    required this.date,
    required this.checkIn,
    required this.label,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
  });

  factory RecentBooking.fromJson(Map<String, dynamic> json) {
    return RecentBooking(
      id: json['id'] ?? '',
      user: json['user'] ?? '',
      userEmail: json['userEmail'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      checkIn:
          DateTime.parse(json['checkIn'] ?? DateTime.now().toIso8601String()),
      label: json['label'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
    );
  }
}

class MonthlyRevenue {
  final String month;
  final double revenue;

  MonthlyRevenue({
    required this.month,
    required this.revenue,
  });

  factory MonthlyRevenue.fromJson(Map<String, dynamic> json) {
    return MonthlyRevenue(
      month: json['month'] ?? '',
      revenue: (json['revenue'] ?? 0).toDouble(),
    );
  }
}
