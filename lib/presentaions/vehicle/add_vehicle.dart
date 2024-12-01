import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zoomio_adminzoomio/data/model/vehicle_model.dart';
import 'package:zoomio_adminzoomio/data/services/database.dart';
import 'package:zoomio_adminzoomio/data/storage/img_storage.dart';
import 'package:zoomio_adminzoomio/presentaions/custom_widgets/buttons.dart';
import 'package:zoomio_adminzoomio/presentaions/custom_widgets/cus_dropdown.dart';
import 'package:zoomio_adminzoomio/presentaions/custom_widgets/vehicle_add_fields.dart';
import 'package:zoomio_adminzoomio/presentaions/home_screen.dart';
import 'package:zoomio_adminzoomio/presentaions/provider/vehicle_provider.dart';
import 'package:zoomio_adminzoomio/presentaions/styles/styles.dart';

class VehicleAddScreen extends StatefulWidget {
  const VehicleAddScreen({super.key});

  @override
  State<VehicleAddScreen> createState() => _VehicleAddScreenState();
}

class _VehicleAddScreenState extends State<VehicleAddScreen> {
  StorageService storageService = StorageService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final vehicleTypeController = TextEditingController();
  final registrationNumberController = TextEditingController();
  final seatingCapacityController = TextEditingController();
  final baseFareController = TextEditingController();
  final waitingChargeController = TextEditingController();
  final perKilometerChargeController = TextEditingController();
  final insurancePolicyNumberController = TextEditingController();
  final complianceDocumentController = TextEditingController();
  final pollutionCertificateController = TextEditingController();
  final pollutionExpiryDateController = TextEditingController();
  final aboutVehicleController = TextEditingController();
  DateTime? insuranceExpiryDate;
  DateTime? pollutionExpiryDate; //  for pollution expiry date
  List<String> selectedVehicleImages = [];
  bool selectedImg = false;
  List<String> selectedDocumentImages = [];
  bool selecetedDoc = false;
  String? selectedVehicleType;
  String? selectedFuelType;
  String? selectedBrand;

  // List of vehicle types
  final List<String> vehicleTypes = ['Car', 'Bike'];

  // List of fuel types
  final List<String> fuelTypes = ['Petrol', 'Diesel', 'Electric'];

  // Example brand lists
  final List<String> carBrands = ['Toyota', 'Honda', 'Ford', 'BMW', 'Nissan'];
  final List<String> bikeBrands = [
    'Yamaha',
    'Kawasaki',
    'Ducati',
    'Suzuki',
    'Honda'
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Vehicle's Details"),
        backgroundColor: ThemeColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Vehicle Type Dropdown
                  CustomDropdownField<String>(
                    value: selectedVehicleType,
                    items: vehicleTypes,
                    labelText: "Select Vehicle Type",
                    onChanged: (value) {
                      setState(() {
                        selectedVehicleType = value;
                        selectedBrand = null; // Reset the selected brand
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a vehicle type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Vehicle Brand Dropdown - Conditional based on vehicle type
                  CustomDropdownField<String>(
                    value: selectedBrand,
                    items: getBrandsForSelectedType(),
                    labelText: "Select Brand",
                    onChanged: (value) {
                      setState(() {
                        selectedBrand = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a brand';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  // Image Selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (selectedVehicleImages
                                .isNotEmpty) // Check if an image is selected
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Image.network(
                                    (selectedVehicleImages[
                                        0]), // Display the only selected image
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () async {
                                  vehicleImages(context); // Open image picker
                                },
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey[
                                        300], // Light background for the icon
                                  ),
                                  child: const Icon(
                                    Icons.add_a_photo,
                                    color: Colors.black,
                                    size: 40, // Adjust size as needed
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  // Registration Number TextField
                  CustomTextField(
                    controller: registrationNumberController,
                    labelText: 'Registration Number',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the registration number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Seating Capacity TextField
                  CustomTextField(
                    controller: seatingCapacityController,
                    labelText: 'Seating Capacity',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the seating capacity';
                      }
                      final int? capacity = int.tryParse(value);
                      if (capacity == null || capacity < 1 || capacity > 10) {
                        return 'Please enter the seating capacity according to vehicle type';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Allow only digits
                      LengthLimitingTextInputFormatter(2),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Fuel Type Dropdown
                  CustomDropdownField<String>(
                    value: selectedFuelType,
                    items: fuelTypes,
                    labelText: "Fuel Type",
                    onChanged: (value) {
                      setState(() {
                        selectedFuelType = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a fuel type';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Insurance Policy Number TextField
                  CustomTextField(
                    controller: insurancePolicyNumberController,
                    labelText: 'Insurance Policy Number',
                    validator: (value) {
                      // Check if the input is empty
                      if (value == null || value.isEmpty) {
                        return 'Please provide the insurance policy number';
                      }
                      // Check for valid format (alphanumeric)
                      if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
                        return 'Insurance policy number can only contain alphanumeric characters';
                      }
                      // Check length (e.g., max length 15 characters)
                      if (value.length > 15) {
                        return 'Insurance policy number must be at most 15 characters long';
                      }
                      return null; // Valid input
                    },
                  ),
                  const SizedBox(height: 20),

                  // Insurance Expiry Date
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                        text: insuranceExpiryDate != null
                            ? "${insuranceExpiryDate!.day}/${insuranceExpiryDate!.month}/${insuranceExpiryDate!.year}"
                            : ''),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(19)),
                      ),
                      labelText: 'Insurance Expiry Date',
                    ),
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          insuranceExpiryDate = selectedDate;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select insurance expiry date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Pollution Certificate Details",
                    style: Textstyles.spclTexts,
                  ),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Pollution Certificate TextField
                  CustomTextField(
                    controller: pollutionCertificateController,
                    labelText: 'Pollution Certificate Number',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide pollution certificate details';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Pollution Expiry Date
                  TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                        text: pollutionExpiryDate != null
                            ? "${pollutionExpiryDate!.day}/${pollutionExpiryDate!.month}/${pollutionExpiryDate!.year}"
                            : ''),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      labelText: 'Pollution Expiry Date',
                    ),
                    onTap: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        setState(() {
                          pollutionExpiryDate = selectedDate;
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select pollution expiry date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  const Text(
                    "Pricing Information",
                    style: Textstyles.spclTexts,
                  ),
                  const Divider(),
                  const SizedBox(height: 18),

                  // Pricing Information - Base Fare
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          controller: baseFareController,
                          labelText: 'Base Fare',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the base fare';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Allow only digits
                            LengthLimitingTextInputFormatter(3),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          controller: waitingChargeController,
                          labelText: 'Waiting Charge',
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the waiting charge';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Allow only digits
                            LengthLimitingTextInputFormatter(3),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: perKilometerChargeController,
                    labelText: 'Per Kilometer Charge',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the charge per kilometer';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // Allow only digits
                      LengthLimitingTextInputFormatter(3),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    controller: aboutVehicleController,
                    labelText: "About Vehicle",
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the details about vehicle ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Display selected document images
                                ...List.generate(
                                  selectedDocumentImages.length,
                                  (index) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Image.network(
                                        (selectedDocumentImages[
                                            index]), // Show the selected document image
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),

                                // GestureDetector to select new document images
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      vehicleDocuments(context);
                                    }, // Call the method to select new images
                                    child: Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey[
                                            300], // Light background for the icon
                                      ),
                                      child: const Icon(
                                        Icons.add_a_photo,
                                        color: Colors.black,
                                        size: 40, // Adjust size as needed
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Save Button
                  CustomButtons(
                      text: "Add Vehicle",
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          Vehicle newVehicle = Vehicle(
                            vehicleType: selectedVehicleType!,
                            brand: selectedBrand!,
                            registrationNumber:
                                registrationNumberController.text,
                            seatingCapacity:
                                int.parse(seatingCapacityController.text),
                            fuelType: selectedFuelType!,
                            insurancePolicyNumber:
                                insurancePolicyNumberController.text,
                            insuranceExpiryDate: insuranceExpiryDate!,
                            pollutionCertificateNumber:
                                pollutionCertificateController.text,
                            pollutionExpiryDate: pollutionExpiryDate!,
                            baseFare: double.parse(baseFareController.text),
                            waitingCharge:
                                double.parse(waitingChargeController.text),
                            perKilometerCharge:
                                double.parse(perKilometerChargeController.text),
                            vehicleImages:
                                selectedVehicleImages, // Add uploaded image URLs
                            documentImages:
                                selectedDocumentImages, // Add uploaded document URLs
                            aboutVehicle: aboutVehicleController
                                .text, // Capture the aboutVehicle text
                          );

                          Provider.of<VehicleProvider>(context, listen: false)
                              .addVehicle(newVehicle);

                          await addVehicle(newVehicle);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.green,
                              content: Text('Vehicle added successfully!'),
                            ),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        }
                      },
                      backgroundColor: ThemeColors.primaryColor,
                      textColor: ThemeColors.textColor,
                      screenWidth: screenWidth,
                      screenHeight: screenHeight),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> getBrandsForSelectedType() {
    if (selectedVehicleType == null) {
      return [];
    }
    return selectedVehicleType == 'Car' ? carBrands : bikeBrands;
  }

  Future<void> vehicleImages(BuildContext context) async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      String? res =
          await StorageService().uploadImage(pickedImage.path, context);
      setState(() {
        // Clear previous image selection
        selectedVehicleImages.clear();
        // Add the newly picked image
        selectedVehicleImages.add(File(res!).path);
        // Set the flag to true since an image is selected
        selectedImg = selectedVehicleImages.isNotEmpty;
      });
    }
  }

  Future<void> vehicleDocuments(BuildContext context) async {
    final imagePicker = ImagePicker();
    final pickedImages = await imagePicker.pickMultiImage();

    if (pickedImages != null && pickedImages.isNotEmpty) {
      // Clear previous selected images
      setState(() {
        selectedDocumentImages.clear();
      });

      // Collect paths
      List<String> paths = []; // Temporary list to collect paths
      for (final multiImg in pickedImages) {
        paths.add(multiImg.path); // Collecting the paths of selected images
      }

      // Use the VehicleDocumentStorageService to upload the selected images
      final vehicleDocumentStorage = VehicleDocumentStorageService();
      List<String?> uploadUrls = await vehicleDocumentStorage
          .uploadMultipleVehicleDocuments(paths, context);

      // Check upload results and add URLs to selectedDocumentImages
      for (String? url in uploadUrls) {
        if (url != null) {
          print("Uploaded Document URL: $url");
          selectedDocumentImages.add(url); // Store the URL instead of the path
        } else {
          print("Upload failed for one of the documents.");
        }
      }

      setState(() {
        selecetedDoc = selectedDocumentImages.isNotEmpty;
      });
    } else {
      print("No images selected.");
    }
  }
}
