import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/feature/hotels/data/repo/hotel_repo.dart';
import 'package:travel_explorer/feature/hotels/presentation/cubit/hotel_state.dart';

class HotelCubit extends Cubit<HotelState> {
  final HotelRepo hotelRepo;

  HotelCubit(this.hotelRepo) : super(HotelInitial());

  Future<void> getHotels({
    required String location,
    required String checkIn,
    required String checkOut,
    int adults = 2,
    int children = 0,
  }) async {
    emit(HotelLoading());

    try {
      final hotels = await hotelRepo.getHotels(
        location: location,
        checkIn: checkIn,
        checkOut: checkOut,
        adults: adults,
        children: children,
      );

      emit(HotelSuccess(hotels));
    } catch (e) {
      emit(
        HotelFailure(
          e.toString(),
        ),
      );
    }
  }
}