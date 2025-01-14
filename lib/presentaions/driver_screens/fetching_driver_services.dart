import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zoomio_adminzoomio/presentaions/driver_screens/driver_profilemodel.dart';

class DriverAdminProvider with ChangeNotifier {
  List<ProfileModel> _drivers = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, bool> _driverOnlineStatus = {};
  Stream<QuerySnapshot>? _statusStream;

  List<ProfileModel> get drivers => _drivers;
  Map<String, bool> get driverOnlineStatus => _driverOnlineStatus;

  DriverAdminProvider() {
    // Initialize the status listener when provider is created
    _listenToDriverStatus();
  }

  void _listenToDriverStatus() {
    _statusStream = _firestore.collection('driverStatus').snapshots();

    _statusStream?.listen((snapshot) {
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final driverId = doc.id;
        final isOnline = data['isOnline'] ?? false;
        final lastSeen = data['lastSeen'];

        // Consider driver offline if last seen is more than 5 minutes ago
        final isActivelyOnline = isOnline && lastSeen != null
            ? DateTime.now()
                    .difference((lastSeen as Timestamp).toDate())
                    .inMinutes <
                5
            : false;

        _driverOnlineStatus[driverId] = isActivelyOnline;
        notifyListeners();
      }
    });
  }

  Future<void> fetchDrivers() async {
    try {
      final querySnapshot = await _firestore.collection('driverProfiles').get();

      _drivers = querySnapshot.docs.map((doc) {
        // Create ProfileModel with document ID
        Map<String, dynamic> data = doc.data();
        data['id'] = doc.id; // Add document ID to the data
        return ProfileModel.fromMap(data);
      }).toList();

      notifyListeners();
    } catch (error) {
      print('Error fetching drivers: $error');
      throw error;
    }
  }

  bool isDriverOnline(String driverId) {
    return _driverOnlineStatus[driverId] ?? false;
  }

  @override
  void dispose() {
    // Clean up stream subscription
    _statusStream?.drain();
    super.dispose();
  }
}
