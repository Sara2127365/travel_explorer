
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travel_explorer/core/localization/app_localizations.dart';

import 'package:travel_explorer/core/notifications/notification_service.dart';
import 'package:travel_explorer/core/widget/header.dart';
import 'package:travel_explorer/feature/fav/presentation/cubit/fav_cubit.dart';
import 'package:travel_explorer/feature/home/data/models/destination_model.dart';
import 'package:travel_explorer/feature/home/presentation/widgets/destination_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: Header(),

      body: BlocBuilder<FavoritesCubit, List<DestinationModel>>(
        builder: (context, favorites) {
          if (favorites.isEmpty) {
            return Center(
              child: Text(
                localization.noFavoriteDestinations,
                style: const TextStyle(
                  fontSize: 16,
                ),
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
                  context
                      .read<FavoritesCubit>()
                      .toggleFavorite(place);
                },
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await NotificationService.scheduleNotification(
            id: 10,
            title: localization.tripReminder,
            body: localization.tripComingSoon,
            scheduledDate: DateTime.now().add(
              const Duration(minutes: 2),
            ),
          );
        },
        child: const Icon(Icons.alarm),
      ),
    );
  }
}

