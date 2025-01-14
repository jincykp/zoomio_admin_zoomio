import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/trip_list_view.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/trip_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';

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

  String formatDateTime(String timestamp) {
    final dateTime = DateTime.parse(timestamp);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  String formatPrice(double price) {
    return NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 2,
      locale: 'en_IN',
    ).format(price);
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
            return Center(child: Text(provider.error!));
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
              itemCount: completedTrips.length,
              itemBuilder: (context, index) {
                final trip = completedTrips[index];
                return CompletedTripCard(trip: trip);
              },
            ),
          );
        },
      ),
    );
  }
}
