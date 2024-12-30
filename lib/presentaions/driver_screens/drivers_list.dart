import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoomio_adminzoomio/presentaions/driver_screens/fetching_driver_services.dart';
import 'package:zoomio_adminzoomio/presentaions/driver_screens/driver_details.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';

class DriversListScreen extends StatelessWidget {
  const DriversListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final driverProvider =
        Provider.of<DriverAdminProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.primaryColor,
        title: const Text(
          "Drivers List",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder(
        future: driverProvider.fetchDrivers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Consumer<DriverAdminProvider>(
            builder: (context, provider, _) {
              if (provider.drivers.isEmpty) {
                return const Center(child: Text('No drivers available.'));
              }

              return ListView.builder(
                itemCount: provider.drivers.length,
                itemBuilder: (context, index) {
                  final driver = provider?.drivers[index];
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DriverProfileScreen(profile: driver),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        radius: 35,
                        backgroundImage: driver?.profileImageUrl != null
                            ? NetworkImage(driver!.profileImageUrl!)
                            : null,
                        child: driver?.profileImageUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(driver!.name),
                      subtitle: Text(
                          'Status: ${driver.isOnline ? 'Online' : 'Offline'}'),
                      trailing: Icon(
                        driver.isOnline ? Icons.circle : Icons.circle_outlined,
                        color: driver.isOnline ? Colors.green : Colors.red,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
