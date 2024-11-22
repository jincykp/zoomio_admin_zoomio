import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/vehicle_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/vehicle/vechicle_screens/full_view_screen.dart';

class BikeTabScreen extends StatefulWidget {
  const BikeTabScreen({super.key});

  @override
  State<BikeTabScreen> createState() => _BikeTabScreenState();
}

class _BikeTabScreenState extends State<BikeTabScreen> {
  void initState() {
    super.initState();

    // Fetching the vehicles data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vehicleProvider =
          Provider.of<VehicleProvider>(context, listen: false);
      vehicleProvider.fetchVehicles(); // Fetching the vehicles data
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Consumer<VehicleProvider>(
          builder: (context, vehicleProvider, child) {
            // Show CircularProgressIndicator if loading
            if (vehicleProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Filter vehicles to show only bikes
            final bikeVehicles = vehicleProvider.vehicles.where((vehicle) {
              print('Vehicle Type: ${vehicle.vehicleType}'); // Add this line
              return vehicle.vehicleType.toLowerCase() == 'bike';
            }).toList();

            // If there are no bikes
            if (bikeVehicles.isEmpty) {
              return const Center(child: Text('No bikes available.'));
            }

            // Display the list of bikes in a grid
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: bikeVehicles.length,
              itemBuilder: (context, index) {
                var vehicle = bikeVehicles[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleFullViewScreen(
                          vehicle: vehicle,
                        ), // Pass the vehicle to the full view screen
                      ),
                    );
                  },
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: Container(
                            width: 135,
                            height: 110,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: vehicle.vehicleImages.isNotEmpty
                                    ? NetworkImage(vehicle.vehicleImages[0])
                                    : const AssetImage('assets/bike.png')
                                        as ImageProvider, // Default image for bikes
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        // Display vehicle name (brand)
                        Text(
                          vehicle.brand,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
