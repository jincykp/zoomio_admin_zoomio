import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zoomio_adminzoomio/data/model/vehicle_model.dart';

class VehicleRepository {
  final CollectionReference _vehiclesCollection =
      FirebaseFirestore.instance.collection('vehicles');

  // Add vehicle
  Future<void> addVehicle(Vehicle vehicle) async {
    final docVehicle = _vehiclesCollection.doc();
    // Create new vehicle with the generated ID
    final vehicleWithId = vehicle.copyWith(id: docVehicle.id);
    await docVehicle.set(vehicleWithId.toMap());
  }

  // Retrieve vehicles
  Future<List<Vehicle>> getVehicles() async {
    final querySnapshot = await _vehiclesCollection.get();
    return querySnapshot.docs.map((doc) {
      return Vehicle.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Update vehicle
  Future<void> updateVehicle(Vehicle vehicle) async {
    if (vehicle.id == null) throw Exception('Vehicle ID cannot be null');
    await _vehiclesCollection.doc(vehicle.id).update(vehicle.toMap());
  }

  // Delete vehicle
  Future<void> deleteVehicle(String vehicleId) async {
    await _vehiclesCollection.doc(vehicleId).delete();
  }

  // Upload image
  Future<String> uploadImage(File imageFile, String fileName) async {
    final ref =
        FirebaseStorage.instance.ref().child('vehicle_images/$fileName');
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask.whenComplete(() => null);
    return await snapshot.ref.getDownloadURL();
  }
}
