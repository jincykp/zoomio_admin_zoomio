import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:zoomio_adminzoomio/data/model/vehicle_model.dart';

//addvehicle
Future<void> addVehicle(Vehicle vehicle) async {
  final docVehicle = FirebaseFirestore.instance.collection('vehicles').doc();
  vehicle.id = docVehicle.id; // Assign Firestore ID to the vehicle model
  await docVehicle.set(vehicle.toMap());
}

//retrieve
Future<List<Vehicle>> getVehicles() async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('vehicles').get();
  return querySnapshot.docs.map((doc) {
    return Vehicle.fromMap(doc.data(), doc.id);
  }).toList();
}

//update
Future<void> updateVehicle(Vehicle vehicle) async {
  await FirebaseFirestore.instance
      .collection('vehicles')
      .doc(vehicle.id)
      .update(vehicle.toMap());
}

//delete
Future<void> deleteVehicle(String vehicleId) async {
  await FirebaseFirestore.instance
      .collection('vehicles')
      .doc(vehicleId)
      .delete();
}
//upload image

Future<String> uploadImage(File imageFile, String fileName) async {
  final ref = FirebaseStorage.instance.ref().child('vehicle_images/$fileName');
  final uploadTask = ref.putFile(imageFile);
  final snapshot = await uploadTask.whenComplete(() => null);
  final imageUrl = await snapshot.ref.getDownloadURL();
  return imageUrl;
}
