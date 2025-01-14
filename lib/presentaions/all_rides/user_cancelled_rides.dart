import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/trip_provider.dart';

class UserCancelledScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class TripListView extends StatelessWidget {
  final List<dynamic> trips;
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
        final tripId = trip['tripId'] ?? 'Unknown';
        final userId = trip['userId'] ?? 'Unknown';
        final vehicleId = trip['vehicleId'] ?? 'Unknown';
        final pickupLocation = trip['pickupLocation'] ?? 'Not Provided';
        final dropOffLocation = trip['dropOffLocation'] ?? 'Not Provided';
        final totalPrice = trip['totalPrice'] ?? 0.0;
        final status = trip['status'] ?? 'Pending';
        final timestamp = trip['timestamp'] ?? 'Unknown';

        return Card(
          margin: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: const Icon(Icons.directions_car),
            title: Text('Trip ID: $tripId'),
            subtitle: Text(
              'User: $userId\nVehicle ID: $vehicleId\nPickup: $pickupLocation\nDropoff: $dropOffLocation\nPrice: \$${totalPrice.toStringAsFixed(2)}\nStatus: $status\nTimestamp: $timestamp',
            ),
          ),
        );
      },
    );
  }
}
