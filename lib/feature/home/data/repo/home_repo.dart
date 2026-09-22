import 'package:travel_explorer/feature/home/data/datasource/home_remote_data_source.dart';
import 'package:travel_explorer/feature/home/data/datasource/image_remote_data_source.dart';
import '../models/destination_model.dart';

class HomeRepo {
  final HomeRemoteDataSource homeRemoteDataSource;
  final ImageRemoteDataSource imageRemoteDataSource;

  HomeRepo(
    this.homeRemoteDataSource,
    this.imageRemoteDataSource,
  );

  Future<List<DestinationModel>> getAllPlaces() async {
    final places = await homeRemoteDataSource.getAllPlaces();

    final placesWithImages = await Future.wait(
      places.map(
        (place) async {
          final imageUrl =
              await imageRemoteDataSource.getDestinationImage(
            '${place.name} ${place.city} ${place.country}',
          );

          return place.copyWith(
            imageUrl: imageUrl,
          );
        },
      ),
    );

    return placesWithImages;
  }
}