import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/core/widget/header.dart';
import 'package:travel_explorer/feature/fav/presentation/cubit/fav_cubit.dart';
import 'package:travel_explorer/feature/home/presentation/cubit/home_cubit.dart';
import 'package:travel_explorer/feature/home/presentation/cubit/home_state.dart';
import 'package:travel_explorer/feature/home/presentation/widgets/destination_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is LoadingHomeState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is FailureHomeState) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is SuccessHomeState) {
            if (state.places.isEmpty) {
              return const Center(
                child: Text('No places found'),
              );
            }

            final searchText = searchController.text.toLowerCase();

            final filteredPlaces = state.places.where((place) {
              return place.name.toLowerCase().contains(searchText) ||
                  place.city.toLowerCase().contains(searchText) ||
                  place.country.toLowerCase().contains(searchText);
            }).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: searchController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: 'Search destinations...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: filteredPlaces.isEmpty
                      ? const Center(
                          child: Text('No destinations found'),
                        )
                      : BlocBuilder<FavoritesCubit, List>(
                          builder: (context, favorites) {
                            return ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: filteredPlaces.length,
                              itemBuilder: (context, index) {
                                final place = filteredPlaces[index];

                                final isFavorite = context
                                    .read<FavoritesCubit>()
                                    .isFavorite(place.placeId);

                                return DestinationCard(
                                  destination: place,
                                  isFavorite: isFavorite,
                                  onFavoritePressed: () {
                                    context
                                        .read<FavoritesCubit>()
                                        .toggleFavorite(place);
                                  },
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}