class HotelModel {
  final String id;
  final String name;
  final String propertyType;
  final String platform;

  final double latitude;
  final double longitude;
  final String city;
  final String region;
  final String country;
  final String address;

  final double starRating;
  final double guestRating;
  final int reviewCount;

  final List<String> amenities;
  final List<String> images;

  final String currency;
  final double nightlyPrice;
  final double totalPrice;
  final int nights;

  final String bookingUrl;

  HotelModel({
    required this.id,
    required this.name,
    required this.propertyType,
    required this.platform,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.region,
    required this.country,
    required this.address,
    required this.starRating,
    required this.guestRating,
    required this.reviewCount,
    required this.amenities,
    required this.images,
    required this.currency,
    required this.nightlyPrice,
    required this.totalPrice,
    required this.nights,
    required this.bookingUrl,
  });

  factory HotelModel.fromHasData(
    Map<String, dynamic> json, {
    required String location,
    required int requestedNights,
  }) {
    final gps =
        json['gpsCoordinates'] as Map<String, dynamic>? ?? {};

    final ratePerNight =
        json['ratePerNight'] as Map<String, dynamic>? ?? {};

    final totalRate =
        json['totalRate'] as Map<String, dynamic>? ?? {};

    final name =
        json['name']?.toString() ?? 'Hotel';

    final nightlyPrice =
        (ratePerNight['extractedLowest'] as num?)
                ?.toDouble() ??
            0;

    final totalPrice =
        (totalRate['extractedLowest'] as num?)
                ?.toDouble() ??
            (nightlyPrice * requestedNights);

    final rating =
        (json['overallRating'] as num?)?.toDouble() ?? 0;

    final reviews =
        (json['reviews'] as num?)?.toInt() ?? 0;

    final hotelClass =
        (json['extractedHotelClass'] as num?)?.toDouble() ??
            0;

    final amenities = (json['amenities'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return HotelModel(
      id: json['propertyToken']?.toString() ??
          name.hashCode.toString(),

      name: name,

      propertyType:
          json['type']?.toString() ?? 'Hotel',

      platform: 'Google',

      latitude:
          (gps['latitude'] as num?)?.toDouble() ?? 0,

      longitude:
          (gps['longitude'] as num?)?.toDouble() ?? 0,

      city: location,

      region: '',

      country: '',

      address: '',

      starRating: hotelClass,

      guestRating: rating,

      reviewCount: reviews,

      amenities: amenities,

      images: const [],

      currency: 'USD',

      nightlyPrice: nightlyPrice,

      totalPrice: totalPrice,

      nights: requestedNights,

      bookingUrl:
          json['link']?.toString() ?? '',
    );
  }
}