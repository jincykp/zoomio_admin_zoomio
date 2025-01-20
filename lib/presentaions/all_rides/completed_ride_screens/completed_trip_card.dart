import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/completed_ride_screens/completed_trip_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/enhanced_trip.dart';

class CompletedTripCard extends StatefulWidget {
  final EnhancedTrip enhancedTrip;

  CompletedTripCard({
    Key? key,
    required this.enhancedTrip,
  }) : super(key: key);

  @override
  State<CompletedTripCard> createState() => _CompletedTripCardState();
}

class _CompletedTripCardState extends State<CompletedTripCard> {
  Future<void> _launchPhone(String phoneNumber) async {
    final Uri uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final trip = widget.enhancedTrip;
    final userDetails = widget.enhancedTrip.userDetails;
    final driverDetails = widget.enhancedTrip.driverDetails;

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
              // User Details Section
              _buildSectionTitle('Customer Details', Icons.person),
              if (userDetails != null) ...[
                _buildDetailRow(
                  'Name',
                  userDetails.displayName,
                  showCopy: true,
                ),
                _buildDetailRow(
                  'Phone',
                  userDetails.phone ?? 'N/A', // Use 'N/A' or any default value
                  onTap: userDetails.phone != null
                      ? () => _launchPhone(userDetails.phone!)
                      : null,
                  showCopy: userDetails.phone != null,
                ),
                _buildDetailRow(
                  'Email',
                  userDetails.email,
                  showCopy: true,
                ),
              ] else
                const Text('User details not available'),

              const SizedBox(height: 16),
              const Divider(),

              // Driver Details Section
              _buildSectionTitle('Driver Details', Icons.drive_eta),
              if (driverDetails != null) ...[
                _buildDetailRow(
                  'Name',
                  driverDetails.name,
                  showCopy: true,
                ),
                _buildDetailRow(
                  'Phone',
                  driverDetails.contactNumber,
                  onTap: () => _launchPhone(driverDetails.contactNumber),
                  showCopy: true,
                ),
              ] else
                const Text('Driver details not available'),

              const SizedBox(height: 16),
              const Divider(),

              // Location Details
              _buildSectionTitle('Trip Details', Icons.location_on),
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

              // Trip Status and Payment
              const SizedBox(height: 16),
              const Divider(),
              _buildSectionTitle('Status & Payment', Icons.info_outline),
              _buildDetailRow('Trip Status', trip.status),
              // _buildDetailRow('Payment Method', trip.paymentMethod ?? 'N/A'),

              if (trip.vehicleDetails != null) ...[
                const SizedBox(height: 16),
                const Divider(),
                _buildSectionTitle('Vehicle Details', Icons.directions_car),
                ...trip.vehicleDetails!.entries.map(
                  (e) => _buildDetailRow(
                    _capitalizeFirstLetter(e.key),
                    e.value.toString(),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    VoidCallback? onTap,
    bool showCopy = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  color: onTap != null ? Colors.blue : null,
                  decoration: onTap != null ? TextDecoration.underline : null,
                ),
              ),
            ),
          ),
          if (showCopy)
            IconButton(
              icon: const Icon(Icons.copy, size: 18),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: value));
              },
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
      decimalDigits: 2,
      locale: 'en_IN',
    ).format(price);
  }

  String formatDuration(int? duration) {
    if (duration == null) return 'N/A';
    final hours = duration ~/ 60;
    final minutes = duration % 60;
    if (hours > 0) {
      return '$hours hr ${minutes > 0 ? '$minutes min' : ''}';
    }
    return '$minutes min';
  }

  String _capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
