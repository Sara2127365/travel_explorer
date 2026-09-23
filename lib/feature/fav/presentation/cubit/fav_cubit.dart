import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/feature/fav/data/repo/fav_repo.dart';
import 'package:travel_explorer/feature/home/data/models/destination_model.dart';

class FavoritesCubit extends Cubit<List<DestinationModel>> {
  final FavoritesRepo favoritesRepo;

  FavoritesCubit(this.favoritesRepo) : super([]);

  void loadFavorites() {
    emit(favoritesRepo.getFavorites());
  }

  Future<void> toggleFavorite(DestinationModel place) async {
    if (favoritesRepo.isFavorite(place.placeId)) {
      await favoritesRepo.removeFavorite(place.placeId);
    } else {
      await favoritesRepo.addFavorite(place);
    }

    loadFavorites();
  }

  bool isFavorite(String placeId) {
    return favoritesRepo.isFavorite(placeId);
  }
}