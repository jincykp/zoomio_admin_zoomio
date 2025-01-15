import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/user_cancelled_screens/enhanced_cancel_trip.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/user_cancelled_screens/user_cancelled_provider.dart';

class UserCancelledScreen extends StatefulWidget {
  @override
  State<UserCancelledScreen> createState() => _UserCancelledScreenState();
}

class _UserCancelledScreenState extends State<UserCancelledScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch cancelled trips when screen loads
    Future.microtask(() =>
        Provider.of<CancelledTripProvider>(context, listen: false)
            .fetchCancelledTrips());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CancelledTripProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          return CancelledTripListView(
            trips: provider.cancelledTrips,
            emptyMessage: 'No cancelled trips found',
          );
        },
      ),
    );
  }
}

class CancelledTripListView extends StatelessWidget {
  final List<EnhancedCancelledTrip> trips;
  final String emptyMessage;

  const CancelledTripListView({
    Key? key,
    required this.trips,
    required this.emptyMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (trips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel_schedule_send_outlined,
                size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: TextStyle(
                fontSize: 18,
                // color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: trips.length,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      itemBuilder: (context, index) {
        final trip = trips[index];

        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cancel_outlined,
                  color: Colors.red[400],
                  size: 24,
                ),
              ),
              title: Text(
                trip.userDetails?.displayName ?? 'Unknown User',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Wrap(
                  spacing: 16,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 14,
                          //  color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatTime(trip.formattedCancelTime),
                          style: TextStyle(
                            fontSize: 13,
                            // color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    // Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   children: [
                    //     Icon(
                    //       Icons.timer_outlined,
                    //       size: 14,
                    //       color: Colors.grey[600],
                    //     ),
                    //     const SizedBox(width: 4),
                    // Text(
                    //   _formatWaitTime(trip.formattedWaitTime),
                    //   style: TextStyle(
                    //     fontSize: 13,
                    //     color: Colors.grey[600],
                    //   ),
                    //   overflow: TextOverflow.ellipsis,
                    // ),
                    //   ],
                    // ),
                  ],
                ),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    ///color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLocationSection(trip),
                      const Divider(height: 24),
                      _buildInfoSection('User Details', [
                        _buildDetailRow(
                          Icons.phone_outlined,
                          trip.userDetails?.phone ?? 'N/A',
                        ),
                        _buildDetailRow(
                          Icons.email_outlined,
                          trip.userDetails?.email ?? 'N/A',
                        ),
                      ]),
                      if (trip.driverDetails != null) ...[
                        const Divider(height: 24),
                        _buildInfoSection('Driver Details', [
                          _buildDetailRow(
                            Icons.person_outline,
                            trip.driverDetails?.name ?? 'Unknown',
                          ),
                          _buildDetailRow(
                            Icons.phone_outlined,
                            trip.driverDetails?.contactNumber ?? 'N/A',
                          ),
                          _buildDetailRow(
                            Icons.directions_car_outlined,
                            trip.driverDetails?.vehiclePreference ?? 'N/A',
                          ),
                        ]),
                      ],
                      const Divider(height: 24),
                      _buildCancellationSection(trip),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            //   color: Colors.green[50],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '\₹ ${trip.totalPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
      },
    );
  }

  String _formatTime(String time) {
    // Assuming time is in a standard format, adjust as needed
    try {
      final DateTime dateTime = DateTime.parse(time);
      return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')} ${dateTime.hour >= 12 ? 'PM' : 'AM'}';
    } catch (e) {
      return time;
    }
  }

  String _formatWaitTime(String waitTime) {
    // Remove any "Wait: " prefix if it exists
    final cleanTime = waitTime.replaceAll('Wait: ', '');
    // You can add additional formatting here if needed
    return 'Wait: $cleanTime';
  }

  Widget _buildLocationSection(EnhancedCancelledTrip trip) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        //  color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLocationRow(
            Icons.trip_origin,
            'Pickup',
            trip.pickupLocation,
            Colors.blue[700]!,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 11,
            ),
            child: Container(
              width: 2,
              height: 24,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue[700]!, Colors.red[700]!],
                ),
              ),
            ),
          ),
          _buildLocationRow(
            Icons.location_on,
            'Dropoff',
            trip.dropOffLocation,
            Colors.red[700]!,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(
    IconData icon,
    String label,
    String location,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 22, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                location,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(String title, List<Widget> details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        ...details,
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCancellationSection(EnhancedCancelledTrip trip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Cancellation Reasons',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        ...trip.allReasons.map((reason) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.remove_circle_outline,
                    size: 18,
                    color: Colors.red[400],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      reason,
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
