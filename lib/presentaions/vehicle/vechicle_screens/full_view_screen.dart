import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/data/model/vehicle_model.dart';
import 'package:zoomio_adminzoomio/presentaions/custom_widgets/buttons.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/vehicle_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';
import 'package:zoomio_adminzoomio/presentaions/vehicle/vechicle_screens/edit_screen.dart';

class VehicleFullViewScreen extends StatefulWidget {
  final Vehicle vehicle;

  const VehicleFullViewScreen({super.key, required this.vehicle});

  @override
  State<VehicleFullViewScreen> createState() => _VehicleFullViewScreenState();
}

class _VehicleFullViewScreenState extends State<VehicleFullViewScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: ThemeColors.primaryColor,
        title: const Text("Vehicle Details"),
      ),
      body: SizedBox(
        height: screenHeight,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 230,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: widget.vehicle.vehicleImages.isNotEmpty
                        ? NetworkImage(widget.vehicle.vehicleImages[0])
                        : const AssetImage('assets/car.png') as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // List of Vehicle Details
              buildVehicleDetailCard(
                  'Vehicle Type', widget.vehicle.vehicleType),
              buildVehicleDetailCard('Brand', widget.vehicle.brand),
              buildVehicleDetailCard('Registration Number',
                  widget.vehicle.registrationNumber ?? 'N/A'),
              buildVehicleDetailCard(
                  'Seating Capacity', '${widget.vehicle.seatingCapacity}'),
              buildVehicleDetailCard(
                  'Fuel Type', widget.vehicle.fuelType ?? 'N/A'),
              buildVehicleDetailCard('Insurance Policy Number',
                  widget.vehicle.insurancePolicyNumber ?? 'N/A'),
              buildVehicleDetailCard('Insurance Expiry Date',
                  formatDate(widget.vehicle.insuranceExpiryDate)),
              buildVehicleDetailCard('Pollution Certificate Number',
                  widget.vehicle.pollutionCertificateNumber ?? 'N/A'),
              buildVehicleDetailCard('Pollution Expiry Date',
                  formatDate(widget.vehicle.pollutionExpiryDate)),
              buildVehicleDetailCard('Base Fare',
                  '\$${widget.vehicle.baseFare.toStringAsFixed(2)}'),
              buildVehicleDetailCard('Waiting Charge',
                  '\$${widget.vehicle.waitingCharge.toStringAsFixed(2)}'),
              buildVehicleDetailCard('Per Kilometer Charge',
                  '\$${widget.vehicle.perKilometerCharge.toStringAsFixed(2)}'),
              const SizedBox(height: 20),
              const Text("Vehicle's Documents"), const Divider(),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.vehicle.documentImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      // height: 280,
                      width: 230,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        image: DecorationImage(
                          image: NetworkImage(
                              widget.vehicle.documentImages[index]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: UniqueButtons(
                        text: "EDIT",
                        onPressed: () {
                          int vehicleIndex = 0;
                          print("edit buttion pressed");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditVehicleScreen(
                                      vehicless: widget.vehicle)));
                        },
                        backgroundColor: ThemeColors.primaryColor,
                        textColor: ThemeColors.textColor),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: UniqueButtons(
                        text: "DELETE",
                        onPressed: () => _confirmDelete(context),
                        backgroundColor: ThemeColors.primaryColor,
                        textColor: ThemeColors.textColor),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build a card for each vehicle detail
  Card buildVehicleDetailCard(String title, String value) {
    return Card(
      child: ListTile(
        title: Text(
          '$title: $value',
          style: Textstyles.dataTexts,
        ),
      ),
    );
  }

  // Method to format DateTime to String
  String formatDate(DateTime? date) {
    if (date == null) {
      return 'N/A'; // or handle null cases as needed
    }
    return DateFormat('yyyy-MM-dd').format(date); // Adjust the format as needed
  } // Method to show confirmation dialog before deleting

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this vehicle?"),
          actions: [
            TextButton(
              child: const Text("CANCEL"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("DELETE"),
              onPressed: () async {
                await Provider.of<VehicleProvider>(context, listen: false)
                    .deleteVehicle(widget.vehicle.id.toString());
                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Go back after deleting
              },
            ),
          ],
        );
      },
    );
  }
}
