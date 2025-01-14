import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/completed_rides.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/driver_cancelled_rides.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/trip_model.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/trip_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/user_cancelled_rides.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({Key? key}) : super(key: key);

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch initial data and start listening for updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<TripProvider>(context, listen: false);
      provider.fetchTrips();
      provider.startRealtimeUpdates();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ThemeColors.primaryColor,
          title: const Text("All Trips"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Completed"),
              Tab(text: "User Cancelled"),
              Tab(text: "Driver Cancelled"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const CompletedRideScreen(),
            UserCancelledScreen(),
            const DriverCancelledRideScreen(),
          ],
        ),
      ),
    );
  }
}
