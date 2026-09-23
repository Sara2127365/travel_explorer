import 'package:travel_explorer/feature/fav/data/datasource/fav_local_data_source.dart';
import 'package:travel_explorer/feature/home/data/models/destination_model.dart';

class FavoritesRepo {
  final FavoritesLocalDataSource favoritesLocalDataSource;

  FavoritesRepo(this.favoritesLocalDataSource);

  Future<void> addFavorite(DestinationModel place) async {
    await favoritesLocalDataSource.addFavorite(place);
  }

  Future<void> removeFavorite(String placeId) async {
    await favoritesLocalDataSource.removeFavorite(placeId);
  }

  bool isFavorite(String placeId) {
    return favoritesLocalDataSource.isFavorite(placeId);
  }

  List<DestinationModel> getFavorites() {
    return favoritesLocalDataSource.getFavorites();
  }
}