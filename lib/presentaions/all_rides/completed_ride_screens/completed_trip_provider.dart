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

  // Use a Map to store trips with tripId as key to prevent duplicates
  Map<String, EnhancedTrip> _tripsMap = {};
  bool _isLoading = false;
  String? _error;

  // Getter that returns sorted list of trips
  List<EnhancedTrip> get trips {
    final tripsList = _tripsMap.values.toList();
    tripsList.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return tripsList;
  }

  bool get isLoading => _isLoading;
  String? get error => _error;

  List<EnhancedTrip> get completedTrips {
    return trips
        .where((trip) => trip.status.toLowerCase() == 'trip_completed')
        .toList();
  }

  Future<void> fetchTrips() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _tripRef.get();
      if (snapshot.exists) {
        await _processTripsData(snapshot.value as Map<dynamic, dynamic>);
      }
    } catch (e) {
      _error = 'Failed to fetch trips: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _processTripsData(Map<dynamic, dynamic> data) async {
    for (var entry in data.entries) {
      final key = entry.key.toString();
      final value = Map<String, dynamic>.from(entry.value as Map);
      final trip = Trip.fromJson(value, key);

      // Only fetch user and driver details if we don't already have this trip
      // or if the existing trip has different status (indicating an update)
      if (!_tripsMap.containsKey(key) ||
          _tripsMap[key]?.status != trip.status) {
        final userDetails = await _fetchUserDetails(trip.userId);
        final driverDetails = trip.driverId != null
            ? await _fetchDriverDetails(trip.driverId!)
            : null;

        _tripsMap[key] = EnhancedTrip(
          trip: trip,
          userDetails: userDetails,
          driverDetails: driverDetails,
        );
      }
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
          await _processTripsData(
              event.snapshot.value as Map<dynamic, dynamic>);
          notifyListeners();
        }
      },
      onError: (error) {
        _error = 'Error in realtime updates: $error';
        notifyListeners();
      },
    );
  }

  // Optional: Method to clear specific trips or reset the provider
  void clearTrips() {
    _tripsMap.clear();
    notifyListeners();
  }
}
