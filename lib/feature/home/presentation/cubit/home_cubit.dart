import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/feature/home/data/models/destination_model.dart';
import 'package:travel_explorer/feature/home/data/repo/home_repo.dart';
import 'package:travel_explorer/feature/home/presentation/cubit/home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepo homeRepo;

  HomeCubit(this.homeRepo) : super(InitialHomeState());

  List<DestinationModel> places = [];

  Future<void> getPLaces() async {
    emit(LoadingHomeState());

    try {
      places = await homeRepo.getAllPlaces();

      emit(SuccessHomeState(places));
    } catch (e) {
      emit(FailureHomeState(e.toString()));
    }
  }
}