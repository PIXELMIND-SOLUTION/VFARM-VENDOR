class FarmhouseModel {
  final String id;
  final String name;
  final List<String> images;
  final String address;
  final String? description;
  final List<String> amenities;
  final double price;
  final double rating;
  final String? feedbackSummary;
  final String? bookingFor;
  final List<TimePrice> timePrices;
  final bool active;
  final Location? location;
  final List<InactiveDate> inactiveDates;
  final DateTime createdAt;
  final String? video;
  final int? noOfPersons;
  final double lat;
  final double lng;

  FarmhouseModel({
    required this.id,
    required this.name,
    required this.images,
    required this.address,
    this.description,
    required this.amenities,
    required this.price,
    required this.rating,
    this.feedbackSummary,
    this.bookingFor,
    required this.timePrices,
    required this.active,
    this.location,
    required this.inactiveDates,
    required this.createdAt,
    this.video,
    this.noOfPersons,
    required this.lat,
    required this.lng,
  });

  factory FarmhouseModel.fromJson(Map<String, dynamic> json) {
    double lat = 0.0;
    double lng = 0.0;
    if (json['location'] != null && json['location']['coordinates'] != null) {
      final coords = json['location']['coordinates'] as List;
      if (coords.length >= 2) {
        lng = (coords[0] as num).toDouble(); // longitude
        lat = (coords[1] as num).toDouble(); // latitude
      }
    }
    return FarmhouseModel(
      id: json['_id'] ?? '',
      lat: lat,
      lng: lng,
      name: json['name'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      address: json['address'] ?? '',
      description: json['description'],
      amenities:
          json['amenities'] != null ? List<String>.from(json['amenities']) : [],
      price: (json['price'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      feedbackSummary: json['feedbackSummary'],
      bookingFor: json['bookingFor'],
      timePrices:
          json['timePrices'] != null && (json['timePrices'] as List).isNotEmpty
              ? (json['timePrices'] as List)
                  .map((e) => TimePrice.fromJson(e))
                  .toList()
              : [],
      active: json['active'] ?? true,
      location:
          json['location'] != null ? Location.fromJson(json['location']) : null,
      inactiveDates: json['inactiveDates'] != null &&
              (json['inactiveDates'] as List).isNotEmpty
          ? (json['inactiveDates'] as List)
              .map((e) => InactiveDate.fromJson(e))
              .toList()
          : [],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      video: json['video'],
      noOfPersons: json['noOfPersons'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'images': images,
      'address': address,
      'description': description,
      'amenities': amenities,
      'price': price,
      'rating': rating,
      'feedbackSummary': feedbackSummary,
      'bookingFor': bookingFor,
      'timePrices': timePrices.map((e) => e.toJson()).toList(),
      'active': active,
      'location': location?.toJson(),
      'inactiveDates': inactiveDates.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'video': video,
      'noOfPersons': noOfPersons,
      'location': {
        'type': 'Point',
        'coordinates': [lng, lat],
      },
    };
  }
}

class TimePrice {
  final String id;
  final String label;
  final String timing;
  final double price;
  final bool isActive;
  final List<InactiveDate> inactiveDates;

  TimePrice({
    required this.id,
    required this.label,
    required this.timing,
    required this.price,
    required this.isActive,
    required this.inactiveDates,
  });

  factory TimePrice.fromJson(Map<String, dynamic> json) {
    return TimePrice(
      id: json['_id'] ?? '',
      label: json['label'] ?? '',
      timing: json['timing'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      isActive: json['isActive'] ?? true,
      inactiveDates: json['inactiveDates'] != null &&
              (json['inactiveDates'] as List).isNotEmpty
          ? (json['inactiveDates'] as List)
              .map((e) => InactiveDate.fromJson(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'label': label,
      'timing': timing,
      'price': price,
      'isActive': isActive,
      'inactiveDates': inactiveDates.map((e) => e.toJson()).toList(),
    };
  }
}

class InactiveDate {
  final String id;
  final DateTime date;
  final String? reason;

  InactiveDate({
    required this.id,
    required this.date,
    this.reason,
  });

  factory InactiveDate.fromJson(Map<String, dynamic> json) {
    return InactiveDate(
      id: json['_id'] ?? '',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      reason: json['reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'date': date.toIso8601String(),
      'reason': reason,
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] ?? 'Point',
      coordinates: json['coordinates'] != null
          ? List<double>.from(json['coordinates'])
          : [0.0, 0.0],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }

  double get lng => coordinates.isNotEmpty ? coordinates[0] : 0.0;
  double get lat => coordinates.length > 1 ? coordinates[1] : 0.0;
}
