import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoomio_adminzoomio/presentaions/driver_screens/driver_profilemodel.dart';

class DriverAdminProvider with ChangeNotifier {
  List<ProfileModel> _drivers = [];

  List<ProfileModel> get drivers => _drivers;

  Future<void> fetchDrivers() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection('drivers').get();
      _drivers = querySnapshot.docs
          .map(
              (doc) => ProfileModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
      notifyListeners(); // Notify UI of changes
    } catch (error) {
      print('Error fetching drivers: $error');
      throw error;
    }
  }
}
