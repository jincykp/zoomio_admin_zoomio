import 'package:flutter/material.dart';
import 'package:zoomio_adminzoomio/presentaions/driver_screens/driver_profilemodel.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';

class DriverProfileScreen extends StatelessWidget {
  final ProfileModel profile;

  const DriverProfileScreen({Key? key, required this.profile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Driver Profile'),
          backgroundColor: ThemeColors.primaryColor),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: profile.profileImageUrl != null
                    ? NetworkImage(profile.profileImageUrl!)
                    : null,
                child: profile.profileImageUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Name', profile.name),
            _buildDetailRow('Age', profile.age.toString()),
            _buildDetailRow('Contact', profile.contactNumber),
            _buildDetailRow('Gender', profile.gender ?? 'Not specified'),
            _buildDetailRow('Vehicle Preference',
                profile.vehiclePreference ?? 'Not specified'),
            _buildDetailRow('Experience', '${profile.experienceYears} years'),
            _buildDetailRow(
                'Online Status', profile.isOnline ? 'Online' : 'Offline'),
            const SizedBox(height: 16),
            if (profile.licenseImageUrl != null) ...[
              const Text(
                'License Image',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Image.network(
                profile.licenseImageUrl!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$title: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}
