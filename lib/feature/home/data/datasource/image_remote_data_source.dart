import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ImageRemoteDataSource {
  final Dio dio;

  ImageRemoteDataSource(this.dio);

  Future<String?> getDestinationImage(String query) async {
    try {
      final response = await dio.get(
        'https://api.unsplash.com/search/photos',
        queryParameters: {
          'query': query,
          'per_page': 1,
          'orientation': 'landscape',
        },
        options: Options(
          headers: {
            'Authorization':
                'Client-ID ${dotenv.env['UNSPLASH_ACCESS_KEY']}',
          },
        ),
      );

      final results = response.data['results'] as List;

      if (results.isEmpty) {
        return null;
      }

      return results.first['urls']['regular'];
    } catch (e) {
      return null;
    }
  }
}