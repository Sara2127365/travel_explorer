class DestinationModel {
  final String name;
  final String country;
  final String countryCode;
  final String city;
  final double lat;
  final double lon;
  final String formatted;
  final String placeId;
  final String? imageUrl;

  DestinationModel({
    required this.name,
    required this.country,
    required this.countryCode,
    required this.city,
    required this.lat,
    required this.lon,
    required this.formatted,
    required this.placeId,
    this.imageUrl,
  });

  // Geoapify response
  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    final properties =
        json['properties'] as Map<String, dynamic>;

    final geometry =
        json['geometry'] as Map<String, dynamic>;

    final coordinates =
        geometry['coordinates'] as List;

    return DestinationModel(
      name: properties['name'] ?? '',
      country: properties['country'] ?? '',
      countryCode: properties['country_code'] ?? '',
      city: properties['city'] ?? '',
      lat: (properties['lat'] ?? coordinates[1]).toDouble(),
      lon: (properties['lon'] ?? coordinates[0]).toDouble(),
      formatted: properties['formatted'] ?? '',
      placeId: properties['place_id'] ?? '',
    );
  }

  // Hive data
  Map<String, dynamic> toHiveJson() {
    return {
      'name': name,
      'country': country,
      'countryCode': countryCode,
      'city': city,
      'lat': lat,
      'lon': lon,
      'formatted': formatted,
      'placeId': placeId,
      'imageUrl': imageUrl,
    };
  }

  // Read data from Hive
  factory DestinationModel.fromHiveJson(
    Map<String, dynamic> json,
  ) {
    return DestinationModel(
      name: json['name'] ?? '',
      country: json['country'] ?? '',
      countryCode: json['countryCode'] ?? '',
      city: json['city'] ?? '',
      lat: (json['lat'] as num).toDouble(),
      lon: (json['lon'] as num).toDouble(),
      formatted: json['formatted'] ?? '',
      placeId: json['placeId'] ?? '',
      imageUrl: json['imageUrl'],
    );
  }

  DestinationModel copyWith({
    String? imageUrl,
  }) {
    return DestinationModel(
      name: name,
      country: country,
      countryCode: countryCode,
      city: city,
      lat: lat,
      lon: lon,
      formatted: formatted,
      placeId: placeId,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}