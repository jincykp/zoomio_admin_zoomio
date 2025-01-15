import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/driver_cancelled_screens/driver_cancelled_provider.dart';

class DriverCancelledRideScreen extends StatefulWidget {
  const DriverCancelledRideScreen({Key? key}) : super(key: key);

  @override
  State<DriverCancelledRideScreen> createState() =>
      _DriverCancelledRideScreenState();
}

class _DriverCancelledRideScreenState extends State<DriverCancelledRideScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<DriverCancelledProvider>().fetchDriverCancelledBookings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DriverCancelledProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading cancelled bookings...')
                ],
              ),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => provider.fetchDriverCancelledBookings(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final bookings = provider.cancelledBookings;
          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.no_accounts, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No cancelled bookings found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchDriverCancelledBookings(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return _buildBookingCard(booking);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(dynamic booking) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserSection(booking),
            const Divider(height: 24),
            _buildDriverSection(booking),
            const Divider(height: 24),
            _buildRideDetails(booking),
          ],
        ),
      ),
    );
  }

  Widget _buildUserSection(dynamic booking) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,
          //  backgroundColor: Colors.grey[200],
          child: Icon(
            Icons.person,
            size: 32,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.userDetails?['displayName'] ?? 'Unknown User',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    booking.userDetails?['phone'] ?? 'N/A',
                    // style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.email,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    booking.userDetails?['email'] ?? 'N/A',
                    //style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDriverSection(dynamic booking) {
    return Row(
      children: [
        const CircleAvatar(
          radius: 24,

          /// backgroundColor: Colors.grey[200],
          child: Icon(
            Icons.drive_eta,
            size: 32,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Driver Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                booking.driverDetails?['name'] ?? 'Unknown Driver',
                //style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRideDetails(dynamic booking) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ride Information',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        _buildLocationRow(
          icon: Icons.location_on,
          label: 'Pickup',
          value: booking.pickupLocation,
        ),
        const SizedBox(height: 8),
        _buildLocationRow(
          icon: Icons.location_off,
          label: 'Dropoff',
          value: booking.dropOffLocation,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Price',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${booking.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(fontSize: 14),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
