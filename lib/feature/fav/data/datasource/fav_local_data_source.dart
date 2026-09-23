import 'package:hive_flutter/hive_flutter.dart';
import 'package:travel_explorer/feature/home/data/models/destination_model.dart';

class FavoritesLocalDataSource {
  final Box favoritesBox;

  FavoritesLocalDataSource(this.favoritesBox);

  Future<void> addFavorite(DestinationModel place) async {
    await favoritesBox.put(
      place.placeId,
      place.toHiveJson(),
    );
  }

  Future<void> removeFavorite(String placeId) async {
    await favoritesBox.delete(placeId);
  }

  bool isFavorite(String placeId) {
    return favoritesBox.containsKey(placeId);
  }

  List<DestinationModel> getFavorites() {
    return favoritesBox.values.map((item) {
      return DestinationModel.fromHiveJson(
        Map<String, dynamic>.from(item),
      );
    }).toList();
  }
}