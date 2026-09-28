import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:travel_explorer/feature/hotels/data/models/hotel_model.dart';

class HotelRemoteDataSource {
  final Dio dio;

  HotelRemoteDataSource(this.dio);

  Future<List<HotelModel>> getHotels({
    required String location,
    required String checkIn,
    required String checkOut,
    int adults = 2,
    int children = 0,
  }) async {
    try {
      final response = await dio.get(
        'https://api.hasdata.com/scrape/google/hotels',
        queryParameters: {
          'q': 'hotels in $location',
          'checkInDate': checkIn,
          'checkOutDate': checkOut,
          'adults': adults,
          'children': children,
          'currency': 'USD',
        },
        options: Options(
          headers: {
            'x-api-key': dotenv.env['HASDATA_API_KEY'],
          },
        ),
      );

      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE: ${response.data}');

      final List data = response.data['properties'] ?? [];

      final checkInDate = DateTime.parse(checkIn);
      final checkOutDate = DateTime.parse(checkOut);

      final nights =
          checkOutDate.difference(checkInDate).inDays;

      return data.map((hotel) {
        return HotelModel.fromHasData(
          hotel as Map<String, dynamic>,
          location: location,
          requestedNights: nights,
        );
      }).toList();
    } on DioException catch (e) {
      debugPrint('DIO ERROR TYPE: ${e.type}');
      debugPrint('DIO STATUS CODE: ${e.response?.statusCode}');
      debugPrint('DIO RESPONSE: ${e.response?.data}');
      debugPrint('DIO MESSAGE: ${e.message}');

      rethrow;
    }
  }
}