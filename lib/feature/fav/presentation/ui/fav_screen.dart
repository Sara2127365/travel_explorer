import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/core/widget/header.dart';
import 'package:travel_explorer/feature/fav/presentation/cubit/fav_cubit.dart';
import 'package:travel_explorer/feature/home/data/models/destination_model.dart';
import 'package:travel_explorer/feature/home/presentation/widgets/destination_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: BlocBuilder<FavoritesCubit, List<DestinationModel>>(
        builder: (context, favorites) {
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'No favorite destinations yet',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final place = favorites[index];

              return DestinationCard(
                destination: place,
                isFavorite: true,
                onFavoritePressed: () {
                  context.read<FavoritesCubit>().toggleFavorite(place);
                },
              );
            },
          );
        },
      ),
    );
  }
}