import 'package:dio/dio.dart';
import '../models/destination_model.dart';
import '../models/global_cities.dart';

class HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSource(this.dio);

  Future<List<DestinationModel>> getAllPlaces() async {
    final List<DestinationModel> allPlaces = [];

    for (final city in GlobalCities.cities) {
      final response = await dio.get(
        'https://api.geoapify.com/v2/places',
        queryParameters: {
          'categories': 'tourism.sights',
          'filter':
              'circle:${city['lon']},${city['lat']},50000',
          'limit': 20,
          'apiKey': '8b2b614c69e44609b650c9c76a2c1bc1',
        },
      );

      final features = response.data['features'] as List;

      for (final feature in features) {
        final place = DestinationModel.fromJson(feature);

        if (place.countryCode.toLowerCase() != 'il') {
          allPlaces.add(place);
        }
      }
    }

    return allPlaces;
  }
}