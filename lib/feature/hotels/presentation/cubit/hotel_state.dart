import 'package:travel_explorer/feature/hotels/data/models/hotel_model.dart';

sealed class HotelState {}

class HotelInitial extends HotelState {}

class HotelLoading extends HotelState {}

class HotelSuccess extends HotelState {
  final List<HotelModel> hotels;

  HotelSuccess(this.hotels);
}

class HotelFailure extends HotelState {
  final String message;

  HotelFailure(this.message);
}