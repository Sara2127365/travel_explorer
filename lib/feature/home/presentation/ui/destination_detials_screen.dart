import 'package:flutter/material.dart';
import 'package:travel_explorer/core/notifications/notification_service.dart';
import 'package:travel_explorer/feature/home/data/models/destination_model.dart';

class DestinationDetailsScreen extends StatelessWidget {
  final DestinationModel destination;

  const DestinationDetailsScreen({
    super.key,
    required this.destination,
  });

  Future<void> _setTripReminder(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
      initialDate: DateTime.now(),
    );

    if (selectedDate == null) {
      return;
    }

    final notificationDate = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      9,
      0,
    );

    await NotificationService.scheduleNotification(
      id: destination.placeId.hashCode,
      title: 'Trip Reminder ✈️',
      body: 'Your trip to ${destination.name} is today!',
      scheduledDate: notificationDate,
    );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Trip reminder set for '
          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              destination.imageUrl ?? '',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const SizedBox(
                  height: 250,
                  child: Center(
                    child: Icon(Icons.image_not_supported),
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    destination.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    destination.formatted,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _setTripReminder(context),
                      icon: const Icon(
                        Icons.notifications_active,
                      ),
                      label: const Text(
                        'Set Trip Reminder',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}