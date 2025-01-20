import 'package:cloud_firestore/cloud_firestore.dart';

enum VehicleStatus { available, onTrip, maintenance }

class Vehicle {
  final String? id;
  final String vehicleType;
  final String brand;
  final String registrationNumber;
  final int seatingCapacity;
  final String fuelType;
  final String insurancePolicyNumber;
  final DateTime insuranceExpiryDate;
  final String pollutionCertificateNumber;
  final DateTime pollutionExpiryDate;
  final double baseFare;
  final double waitingCharge;
  final double perKilometerCharge;
  final List<String> vehicleImages;
  final List<String> documentImages;
  final String aboutVehicle;
  final String status;

  Vehicle({
    this.id,
    required this.vehicleType,
    required this.brand,
    required this.registrationNumber,
    required this.seatingCapacity,
    required this.fuelType,
    required this.insurancePolicyNumber,
    required this.insuranceExpiryDate,
    required this.pollutionCertificateNumber,
    required this.pollutionExpiryDate,
    required this.baseFare,
    required this.waitingCharge,
    required this.perKilometerCharge,
    required this.vehicleImages,
    required this.documentImages,
    required this.aboutVehicle,
    this.status = 'available',
  });

  Map<String, dynamic> toMap() {
    return {
      'vehicleType': vehicleType,
      'brand': brand,
      'registrationNumber': registrationNumber,
      'seatingCapacity': seatingCapacity,
      'fuelType': fuelType,
      'insurancePolicyNumber': insurancePolicyNumber,
      'insuranceExpiryDate':
          Timestamp.fromDate(insuranceExpiryDate), // Convert to Timestamp
      'pollutionCertificateNumber': pollutionCertificateNumber,
      'pollutionExpiryDate':
          Timestamp.fromDate(pollutionExpiryDate), // Convert to Timestamp
      'baseFare': baseFare,
      'waitingCharge': waitingCharge,
      'perKilometerCharge': perKilometerCharge,
      'vehicleImages': vehicleImages,
      'documentImages': documentImages,
      'aboutVehicle': aboutVehicle,
      'status': status,
    };
  }

  static Vehicle fromMap(Map<String, dynamic> map, String documentId) {
    return Vehicle(
      id: documentId,
      vehicleType: map['vehicleType'] ?? '',
      brand: map['brand'] ?? '',
      registrationNumber: map['registrationNumber'] ?? '',
      seatingCapacity: map['seatingCapacity'] ?? 0,
      fuelType: map['fuelType'] ?? '',
      insurancePolicyNumber: map['insurancePolicyNumber'] ?? '',
      insuranceExpiryDate: map['insuranceExpiryDate'] is Timestamp
          ? (map['insuranceExpiryDate'] as Timestamp).toDate()
          : DateTime.now(), // Provide a default date if conversion fails
      pollutionCertificateNumber: map['pollutionCertificateNumber'] ?? '',
      pollutionExpiryDate: map['pollutionExpiryDate'] is Timestamp
          ? (map['pollutionExpiryDate'] as Timestamp).toDate()
          : DateTime.now(), // Provide a default date if conversion fails
      baseFare: (map['baseFare'] ?? 0).toDouble(),
      waitingCharge: (map['waitingCharge'] ?? 0).toDouble(),
      perKilometerCharge: (map['perKilometerCharge'] ?? 0).toDouble(),
      vehicleImages: List<String>.from(map['vehicleImages'] ?? []),
      documentImages: List<String>.from(map['documentImages'] ?? []),
      aboutVehicle: map['aboutVehicle'] ?? '',
      status: map['status'] ?? 'available',
    );
  }

  Vehicle copyWith({
    String? id,
    String? vehicleType,
    String? brand,
    String? registrationNumber,
    int? seatingCapacity,
    String? fuelType,
    String? insurancePolicyNumber,
    DateTime? insuranceExpiryDate,
    String? pollutionCertificateNumber,
    DateTime? pollutionExpiryDate,
    double? baseFare,
    double? waitingCharge,
    double? perKilometerCharge,
    List<String>? vehicleImages,
    List<String>? documentImages,
    String? aboutVehicle,
    String? status,
  }) {
    return Vehicle(
      id: id ?? this.id,
      vehicleType: vehicleType ?? this.vehicleType,
      brand: brand ?? this.brand,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      seatingCapacity: seatingCapacity ?? this.seatingCapacity,
      fuelType: fuelType ?? this.fuelType,
      insurancePolicyNumber:
          insurancePolicyNumber ?? this.insurancePolicyNumber,
      insuranceExpiryDate: insuranceExpiryDate ?? this.insuranceExpiryDate,
      pollutionCertificateNumber:
          pollutionCertificateNumber ?? this.pollutionCertificateNumber,
      pollutionExpiryDate: pollutionExpiryDate ?? this.pollutionExpiryDate,
      baseFare: baseFare ?? this.baseFare,
      waitingCharge: waitingCharge ?? this.waitingCharge,
      perKilometerCharge: perKilometerCharge ?? this.perKilometerCharge,
      vehicleImages: vehicleImages ?? this.vehicleImages,
      documentImages: documentImages ?? this.documentImages,
      aboutVehicle: aboutVehicle ?? this.aboutVehicle,
      status: status ?? this.status,
    );
  }
}
