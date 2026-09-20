import 'package:travel_explorer/feature/home/data/models/destination_model.dart';

abstract class HomeState {}

class InitialHomeState extends HomeState {}

class LoadingHomeState extends HomeState {}

class SuccessHomeState extends HomeState {
  final List<DestinationModel> places;

  SuccessHomeState(this.places);

}

class FailureHomeState extends HomeState {
  final String message;

  FailureHomeState(this.message);
}
