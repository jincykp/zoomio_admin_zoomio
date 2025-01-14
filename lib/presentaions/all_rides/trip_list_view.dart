import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/trip_model.dart';

class TripListView extends StatelessWidget {
  final List<Trip> trips;
  final String emptyMessage;

  const TripListView({
    Key? key,
    required this.trips,
    required this.emptyMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return Center(child: Text(emptyMessage));
    }
    return ListView.builder(
      itemCount: trips.length,
      itemBuilder: (context, index) {
        final trip = trips[index];
        return ListTile(
          title: Text(trip.pickupLocation),
          subtitle: Text(trip.dropOffLocation),
          trailing: Text(trip.status),
          onTap: () {
            // Handle trip click
          },
        );
      },
    );
  }
}

class CompletedTripCard extends StatelessWidget {
  final Trip trip;

  const CompletedTripCard({
    Key? key,
    required this.trip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        childrenPadding: const EdgeInsets.all(16.0),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              formatDateTime(trip.timestamp),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatPrice(trip.totalPrice),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLocationInfo(
                'Pickup Location',
                trip.pickupLocation,
                Icons.trip_origin,
                Colors.green,
              ),
              const SizedBox(height: 16),
              _buildLocationInfo(
                'Drop-off Location',
                trip.dropOffLocation,
                Icons.location_on,
                Colors.red,
              ),
              if (trip.vehicleDetails != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Vehicle Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    // color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 8),
                ...trip.vehicleDetails!.entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 170,
                          child: Text(
                            '${_capitalizeFirstLetter(e.key)}: ',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            e.value.toString(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(
    String label,
    String location,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    // color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String formatDateTime(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return DateFormat('EEE, dd MMM yyyy • hh:mm a').format(dateTime);
  }

  String formatPrice(double price) {
    return NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2, // Set to 2 decimal places
      locale: 'en_IN',
    ).format(price);
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
