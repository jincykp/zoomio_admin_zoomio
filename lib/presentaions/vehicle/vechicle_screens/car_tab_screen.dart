import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/vehicle_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/vehicle/vechicle_screens/full_view_screen.dart';

class CarTabScreen extends StatefulWidget {
  const CarTabScreen({super.key}); // Make the constructor const

  @override
  State<CarTabScreen> createState() => _CarTabScreenState();
}

class _CarTabScreenState extends State<CarTabScreen> {
  @override
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
            if (vehicleProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // Filter vehicles to show only cars
            final carVehicles = vehicleProvider.vehicles
                .where((vehicle) => vehicle.vehicleType == 'Car')
                .toList();

            if (carVehicles.isEmpty) {
              return const Center(child: Text('No vehicles available.'));
            }

            // Display the list of car vehicles in a grid
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemCount: carVehicles.length,
              itemBuilder: (context, index) {
                var vehicle = carVehicles[index];
                if (vehicle == null) {
                  return const SizedBox(); // If vehicle is null, return an empty widget
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VehicleFullViewScreen(
                          vehicle: vehicle,
                        ),
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
                                    : const AssetImage('assets/car.png')
                                        as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
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
