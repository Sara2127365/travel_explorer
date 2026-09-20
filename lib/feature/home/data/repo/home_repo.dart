import 'package:travel_explorer/feature/home/data/datasource/home_remote_data_source.dart';
import 'package:travel_explorer/feature/home/data/models/destination_model.dart';

class HomeRepo {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepo(this.homeRemoteDataSource);

  Future<List<DestinationModel>> getAllPlaces() async {
    return await homeRemoteDataSource.getAllPlaces();
  }
}
