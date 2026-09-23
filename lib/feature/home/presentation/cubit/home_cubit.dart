import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/feature/home/data/models/destination_model.dart';
import 'package:travel_explorer/feature/home/data/repo/home_repo.dart';
import 'package:travel_explorer/feature/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(InitialHomeState());

  List<DestinationModel> places = [];

  List<String> favoritePlaceIds = [];

  Future<void> getPLaces() async {
    emit(LoadingHomeState());

    try {
      places = await homeRepo.getAllPlaces();

      emit(SuccessHomeState(places));
    } catch (e) {
      emit(FailureHomeState(e.toString()));
    }
  }

  void toggleFavorite(DestinationModel place) {
    if (favoritePlaceIds.contains(place.placeId)) {
      favoritePlaceIds.remove(place.placeId);
    } else {
      favoritePlaceIds.add(place.placeId);
    }

    emit(SuccessHomeState(places));
  }
}