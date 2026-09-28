import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travel_explorer/core/notifications/notification_service.dart';
import 'package:travel_explorer/feature/hotels/data/models/hotel_model.dart';

class HotelCard extends StatelessWidget {
  final HotelModel hotel;
  final DateTime? checkInDate;

  const HotelCard({
    super.key,
    required this.hotel,
    this.checkInDate,
  });

  Future<void> _openHotel() async {
    if (hotel.bookingUrl.isEmpty) {
      return;
    }

    final uri = Uri.tryParse(hotel.bookingUrl);

    if (uri == null) {
      return;
    }

    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Launch error: $e');
    }
  }

  Future<void> _setTripReminder(BuildContext context) async {
    if (checkInDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please select a check-in date first.',
          ),
        ),
      );
      return;
    }

    final notificationDate = DateTime(
      checkInDate!.year,
      checkInDate!.month,
      checkInDate!.day,
      9,
      0,
    );

    await NotificationService.scheduleNotification(
      id: hotel.id.hashCode,
      title: 'Trip Reminder ✈️',
      body: 'Your trip to ${hotel.city} is today!',
      scheduledDate: notificationDate,
    );

    if (!context.mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Trip reminder set for '
          '${checkInDate!.day}/'
          '${checkInDate!.month}/'
          '${checkInDate!.year}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImage(),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        hotel.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    if (hotel.platform.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          hotel.platform.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 6),

                if (hotel.propertyType.isNotEmpty)
                  Text(
                    hotel.propertyType,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),

                const SizedBox(height: 6),

                Text(
                  '${hotel.city}, ${hotel.country}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      hotel.guestRating.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '(${hotel.reviewCount} reviews)',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                if (hotel.starRating > 0)
                  Row(
                    children: [
                      ...List.generate(
                        hotel.starRating.round(),
                        (index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 10),

                if (hotel.amenities.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: hotel.amenities.take(5).map(
                      (amenity) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            _formatAmenity(amenity),
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ).toList(),
                  ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      '${hotel.currency} '
                      '${hotel.nightlyPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '/ night',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                Text(
                  'Estimated total: ${hotel.currency} '
                  '${hotel.totalPrice.toStringAsFixed(0)} '
                  'for ${hotel.nights} nights',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 12),

                // Trip reminder
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _setTripReminder(context),
                    icon: const Icon(
                      Icons.notifications_active_outlined,
                    ),
                    label: const Text(
                      'Set Trip Reminder',
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // View hotel
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        hotel.bookingUrl.isEmpty ? null : _openHotel,
                    child: const Text('View Hotel'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatAmenity(String amenity) {
    return amenity
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) {
            if (word.isEmpty) {
              return word;
            }

            return word[0].toUpperCase() + word.substring(1);
          },
        )
        .join(' ');
  }

  Widget _buildImage() {
    if (hotel.images.isEmpty) {
      return _placeholderImage();
    }

    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(12),
      ),
      child: Image.network(
        hotel.images.first,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) {
          return _placeholderImage();
        },
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.hotel,
        size: 60,
      ),
    );
  }
}