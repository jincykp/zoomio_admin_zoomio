import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/enhanced_trip.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/trip_model.dart';
import 'package:zoomio_adminzoomio/presentaions/driver_screens/driver_profilemodel.dart';
import 'package:zoomio_adminzoomio/presentaions/user_screens/user_model.dart';

class TripProvider with ChangeNotifier {
  final DatabaseReference _tripRef = FirebaseDatabase.instance.ref('bookings');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<EnhancedTrip> _trips = [];
  bool _isLoading = false;
  String? _error;

  List<EnhancedTrip> get trips => _trips;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<EnhancedTrip> get completedTrips {
    return _trips
        .where((trip) => trip.status.toLowerCase() == 'trip completed')
        .toList();
  }

  Future<void> fetchTrips() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _tripRef.get();
      if (snapshot.exists) {
        _trips = [];
        final data = snapshot.value as Map<dynamic, dynamic>;

        for (var entry in data.entries) {
          final key = entry.key.toString();
          final value = Map<String, dynamic>.from(entry.value as Map);
          final trip = Trip.fromJson(value, key);

          final userDetails = await _fetchUserDetails(trip.userId);
          final driverDetails = trip.driverId != null
              ? await _fetchDriverDetails(trip.driverId!)
              : null;

          _trips.add(EnhancedTrip(
              trip: trip,
              userDetails: userDetails,
              driverDetails: driverDetails));
        }

        // Sort trips by timestamp (newest first)
        _trips.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      }
    } catch (e) {
      _error = 'Failed to fetch trips: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> _fetchUserDetails(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
    } catch (e) {
      print('Error fetching user details for $userId: $e');
    }
    return null;
  }

  Future<ProfileModel?> _fetchDriverDetails(String driverId) async {
    try {
      final doc =
          await _firestore.collection('driverProfiles').doc(driverId).get();
      if (doc.exists) {
        return ProfileModel.fromFirestore(doc);
      }
    } catch (e) {
      print('Error fetching driver details for $driverId: $e');
    }
    return null;
  }

  void startRealtimeUpdates() {
    _tripRef.onValue.listen(
      (event) async {
        if (event.snapshot.exists) {
          _trips = [];
          final data = event.snapshot.value as Map<dynamic, dynamic>;

          for (var entry in data.entries) {
            final key = entry.key.toString();
            final value = Map<String, dynamic>.from(entry.value as Map);
            final trip = Trip.fromJson(value, key);

            final userDetails = await _fetchUserDetails(trip.userId);
            final driverDetails = trip.driverId != null
                ? await _fetchDriverDetails(trip.driverId!)
                : null;

            _trips.add(EnhancedTrip(
                trip: trip,
                userDetails: userDetails,
                driverDetails: driverDetails));
          }

          _trips.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          notifyListeners();
        }
      },
      onError: (error) {
        _error = 'Error in realtime updates: $error';
        notifyListeners();
      },
    );
  }
}
