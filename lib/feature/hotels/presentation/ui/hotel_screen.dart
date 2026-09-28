
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get_it/get_it.dart';
import 'package:travel_explorer/core/localization/app_localizations.dart';
import 'package:travel_explorer/core/widget/header.dart';

import 'package:travel_explorer/feature/hotels/presentation/cubit/hotel_cubit.dart';
import 'package:travel_explorer/feature/hotels/presentation/cubit/hotel_state.dart';
import 'package:travel_explorer/feature/hotels/presentation/widgets/hotel_card.dart';

class HotelsScreen extends StatefulWidget {
  const HotelsScreen({super.key});

  @override
  State<HotelsScreen> createState() => _HotelsScreenState();
}

class _HotelsScreenState extends State<HotelsScreen> {
  late final HotelCubit hotelCubit;

  final TextEditingController locationController =
      TextEditingController();

  DateTime? checkInDate;
  DateTime? checkOutDate;

  int adults = 2;
  int children = 0;

  @override
  void initState() {
    super.initState();

    hotelCubit = GetIt.I<HotelCubit>();
  }

  @override
  void dispose() {
    locationController.dispose();
    hotelCubit.close();
    super.dispose();
  }

  Future<void> selectCheckInDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      setState(() {
        checkInDate = selectedDate;

        if (checkOutDate != null &&
            !checkOutDate!.isAfter(selectedDate)) {
          checkOutDate = null;
        }
      });
    }
  }

  Future<void> selectCheckOutDate() async {
    final localization = AppLocalizations.of(context)!;

    if (checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localization.pleaseSelectCheckIn,
          ),
        ),
      );
      return;
    }

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: checkInDate!.add(
        const Duration(days: 1),
      ),
      firstDate: checkInDate!.add(
        const Duration(days: 1),
      ),
      lastDate: DateTime(2030),
    );

    if (selectedDate != null) {
      setState(() {
        checkOutDate = selectedDate;
      });
    }
  }

  void searchHotels() {
    final localization = AppLocalizations.of(context)!;

    final location = locationController.text.trim();

    if (location.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localization.pleaseEnterDestination,
          ),
        ),
      );
      return;
    }

    if (checkInDate == null || checkOutDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            localization.pleaseSelectDates,
          ),
        ),
      );
      return;
    }

    hotelCubit.getHotels(
      location: location,
      checkIn: formatDate(checkInDate!),
      checkOut: formatDate(checkOutDate!),
      adults: adults,
      children: children,
    );
  }

  String formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  String formatSelectedDate(DateTime? date) {
    final localization = AppLocalizations.of(context)!;

    if (date == null) {
      return localization.selectDate;
    }

    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: hotelCubit,
      child: Scaffold(
        appBar: Header(),

        body: Column(
          children: [
            _buildSearchSection(localization),

            const SizedBox(height: 8),

            Expanded(
              child: BlocBuilder<HotelCubit, HotelState>(
                builder: (context, state) {
                  if (state is HotelLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is HotelFailure) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  if (state is HotelSuccess) {
                    if (state.hotels.isEmpty) {
                      return Center(
                        child: Text(
                          localization.noHotelsFound,
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.hotels.length,
                      itemBuilder: (context, index) {
                        return HotelCard(
                          hotel: state.hotels[index],
                          checkInDate: checkInDate,
                        );
                      },
                    );
                  }

                  return Center(
                    child: Text(
                      localization.searchHotelsHint,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection(
    AppLocalizations localization,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: locationController,
            decoration: InputDecoration(
              labelText: localization.destination,
              hintText: localization.destinationExample,
              prefixIcon: const Icon(
                Icons.location_on_outlined,
              ),
              border: const OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: selectCheckInDate,
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                  ),
                  label: Text(
                    formatSelectedDate(checkInDate),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: selectCheckOutDate,
                  icon: const Icon(
                    Icons.calendar_today_outlined,
                  ),
                  label: Text(
                    formatSelectedDate(checkOutDate),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localization.adults,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Row(
                children: [
                  IconButton(
                    onPressed: adults > 1
                        ? () {
                            setState(() {
                              adults--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.remove),
                  ),

                  Text(
                    '$adults',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      setState(() {
                        adults++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                localization.children,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              Row(
                children: [
                  IconButton(
                    onPressed: children > 0
                        ? () {
                            setState(() {
                              children--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.remove),
                  ),

                  Text(
                    '$children',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      setState(() {
                        children++;
                      });
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: searchHotels,
              icon: const Icon(Icons.search),
              label: Text(
                localization.searchHotels,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

