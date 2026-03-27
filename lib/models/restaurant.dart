import 'dart:math';

class Restaurant {
  final String placeId;
  final String name;
  final double lat;
  final double lng;
  final double? rating;
  final int? userRatingsTotal;
  final String? address;
  final bool? isOpen;
  final int? priceLevel;
  final List<String> photoReferences;
  final List<String> types;
  // Detail fields
  final String? phoneNumber;
  final String? website;
  final List<Review>? reviews;
  final List<OpeningHoursPeriod>? openingHours;
  final String? openingHoursText;

  Restaurant({
    required this.placeId,
    required this.name,
    required this.lat,
    required this.lng,
    this.rating,
    this.userRatingsTotal,
    this.address,
    this.isOpen,
    this.priceLevel,
    this.photoReferences = const [],
    this.types = const [],
    this.phoneNumber,
    this.website,
    this.reviews,
    this.openingHours,
    this.openingHoursText,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry']?['location'] ?? {};
    final photos = (json['photos'] as List<dynamic>?)
            ?.map((p) => p['photo_reference'] as String)
            .toList() ??
        [];

    return Restaurant(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? '',
      lat: (geometry['lat'] ?? 0).toDouble(),
      lng: (geometry['lng'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      userRatingsTotal: json['user_ratings_total'] ?? 0,
      address: json['vicinity'] ?? json['formatted_address'] ?? '',
      isOpen: json['opening_hours']?['open_now'],
      priceLevel: json['price_level'],
      photoReferences: photos,
      types: List<String>.from(json['types'] ?? []),
    );
  }

  factory Restaurant.fromDetailJson(Map<String, dynamic> json) {
    final geometry = json['geometry']?['location'] ?? {};
    final photos = (json['photos'] as List<dynamic>?)
            ?.map((p) => p['photo_reference'] as String)
            .toList() ??
        [];
    final reviews = (json['reviews'] as List<dynamic>?)
            ?.map((r) => Review.fromJson(r))
            .toList() ??
        [];

    String? openingText;
    List<OpeningHoursPeriod>? periods;
    if (json['opening_hours'] != null) {
      openingText =
          (json['opening_hours']['weekday_text'] as List<dynamic>?)?.join('\n');
      periods = (json['opening_hours']['periods'] as List<dynamic>?)
          ?.map((p) => OpeningHoursPeriod.fromJson(p))
          .toList();
    }

    return Restaurant(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? '',
      lat: (geometry['lat'] ?? 0).toDouble(),
      lng: (geometry['lng'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      userRatingsTotal: json['user_ratings_total'] ?? 0,
      address: json['formatted_address'] ?? json['vicinity'] ?? '',
      isOpen: json['opening_hours']?['open_now'],
      priceLevel: json['price_level'],
      photoReferences: photos,
      types: List<String>.from(json['types'] ?? []),
      phoneNumber: json['formatted_phone_number'],
      website: json['website'],
      reviews: reviews,
      openingHours: periods,
      openingHoursText: openingText,
    );
  }

  String get priceLevelText {
    if (priceLevel == null) return '';
    return List.filled(priceLevel!, '\u20BA').join();
  }

  double distanceTo(double otherLat, double otherLng) {
    const double earthRadius = 6371000;
    final dLat = (otherLat - lat) * pi / 180;
    final dLng = (otherLng - lng) * pi / 180;
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat * pi / 180) * cos(otherLat * pi / 180) *
        sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }
}

class Review {
  final String authorName;
  final String? profilePhotoUrl;
  final double rating;
  final String text;
  final String relativeTimeDescription;

  Review({
    required this.authorName,
    this.profilePhotoUrl,
    required this.rating,
    required this.text,
    required this.relativeTimeDescription,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      authorName: json['author_name'] ?? '',
      profilePhotoUrl: json['profile_photo_url'],
      rating: (json['rating'] ?? 0).toDouble(),
      text: json['text'] ?? '',
      relativeTimeDescription: json['relative_time_description'] ?? '',
    );
  }
}

class OpeningHoursPeriod {
  final int? openDay;
  final String? openTime;
  final int? closeDay;
  final String? closeTime;

  OpeningHoursPeriod({
    this.openDay,
    this.openTime,
    this.closeDay,
    this.closeTime,
  });

  factory OpeningHoursPeriod.fromJson(Map<String, dynamic> json) {
    return OpeningHoursPeriod(
      openDay: json['open']?['day'],
      openTime: json['open']?['time'],
      closeDay: json['close']?['day'],
      closeTime: json['close']?['time'],
    );
  }
}
