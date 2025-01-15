import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/completed_ride_screens/completed_trip_card.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/completed_ride_screens/completed_trip_provider.dart';

class CompletedRideScreen extends StatefulWidget {
  const CompletedRideScreen({Key? key}) : super(key: key);

  @override
  State<CompletedRideScreen> createState() => _CompletedRideScreenState();
}

class _CompletedRideScreenState extends State<CompletedRideScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch initial data
    Future.microtask(
      () => context.read<TripProvider>().fetchTrips(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TripProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(provider.error!),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchTrips(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final completedTrips = provider.completedTrips;

          if (completedTrips.isEmpty) {
            return const Center(
              child: Text(
                'No completed rides found',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchTrips(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: completedTrips.length,
              itemBuilder: (context, index) {
                final enhancedTrip = completedTrips[index];
                return CompletedTripCard(enhancedTrip: enhancedTrip);
              },
            ),
          );
        },
      ),
    );
  }
}
