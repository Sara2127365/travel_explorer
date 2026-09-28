import 'package:travel_explorer/feature/hotels/data/datasource/hotel_remote_data_source.dart';
import 'package:travel_explorer/feature/hotels/data/models/hotel_model.dart';

class HotelRepo {
  final HotelRemoteDataSource remoteDataSource;

  HotelRepo(this.remoteDataSource);

  Future<List<HotelModel>> getHotels({
    required String location,
    required String checkIn,
    required String checkOut,
    int adults = 2,
    int children = 0,
  }) {
    return remoteDataSource.getHotels(
      location: location,
      checkIn: checkIn,
      checkOut: checkOut,
      adults: adults,
      children: children,
    );
  }
}