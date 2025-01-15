import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/user_cancelled_screens/enhanced_cancel_trip.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/trip_model.dart';
import 'package:zoomio_adminzoomio/presentaions/user_screens/user_model.dart';
import 'package:zoomio_adminzoomio/presentaions/driver_screens/driver_profilemodel.dart';

class CancelledTripProvider with ChangeNotifier {
  final DatabaseReference _tripRef = FirebaseDatabase.instance.ref('bookings');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<EnhancedCancelledTrip> _cancelledTrips = [];
  bool _isLoading = false;
  String? _error;

  List<EnhancedCancelledTrip> get cancelledTrips => _cancelledTrips;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCancelledTrips() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final snapshot = await _tripRef
          .orderByChild('status')
          .equalTo('customer_cancelled')
          .get();

      if (snapshot.exists) {
        _cancelledTrips = [];
        final data = snapshot.value as Map<dynamic, dynamic>;

        for (var entry in data.entries) {
          final key = entry.key.toString();
          final value = Map<String, dynamic>.from(entry.value as Map);

          // Parse timestamps to ensure they're integers
          int timestamp = 0;
          if (value['timestamp'] != null) {
            if (value['timestamp'] is num) {
              timestamp = (value['timestamp'] as num).toInt();
            } else if (value['timestamp'] is String) {
              timestamp = int.tryParse(value['timestamp']) ?? 0;
            }
          }

          int cancelledAt = 0;
          if (value['cancelledAt'] != null) {
            if (value['cancelledAt'] is num) {
              cancelledAt = (value['cancelledAt'] as num).toInt();
            } else if (value['cancelledAt'] is String) {
              cancelledAt = int.tryParse(value['cancelledAt']) ?? 0;
            }
          }

          // Parse totalPrice correctly
          double totalPrice = 0.0;
          if (value['totalPrice'] != null) {
            if (value['totalPrice'] is num) {
              totalPrice = (value['totalPrice'] as num).toDouble();
            } else if (value['totalPrice'] is String) {
              totalPrice = double.tryParse(value['totalPrice']) ?? 0.0;
            }
          }

          // Create base Trip object
          final trip = Trip(
            tripId: key,
            pickupLocation: value['pickupLocation'] ?? '',
            dropOffLocation: value['dropOffLocation'] ?? '',
            status: value['status'] ?? '',
            totalPrice: totalPrice,
            timestamp: timestamp.toString(), // Convert to string for Trip model
            userId: value['userId'] ?? '',
            driverId: value['driverId'],
            vehicleDetails: value['vehicleDetails'] is Map
                ? Map<String, dynamic>.from(value['vehicleDetails'] as Map)
                : null,
          );

          // Fetch additional details
          final userDetails = await _fetchUserDetails(value['userId']);
          final driverDetails = value['driverId'] != null
              ? await _fetchDriverDetails(value['driverId'])
              : null;

          // Create cancellation data map with parsed timestamps
          final cancellationData = {
            'reasonsList': value['reasonsList'] ?? [],
            'otherReason': value['otherReason'] ?? '',
            'cancelledAt': cancelledAt, // Use the parsed integer
          };

          final enhancedTrip = EnhancedCancelledTrip.fromTrip(
            trip: trip,
            userDetails: userDetails,
            driverDetails: driverDetails,
            cancellationData: cancellationData,
          );

          _cancelledTrips.add(enhancedTrip);
        }

        // Sort by cancellation timestamp (newest first)
        _cancelledTrips.sort((a, b) => b.cancelledAt.compareTo(a.cancelledAt));
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack trace: $stackTrace');
      _error = 'Failed to fetch cancelled trips: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<UserModel?> _fetchUserDetails(String? userId) async {
    if (userId == null) {
      print('UserId is null, skipping user details fetch'); // Debug print
      return null;
    }

    try {
      print('Fetching user document for userId: $userId'); // Debug print
      final doc = await _firestore.collection('users').doc(userId).get();
      print('User document exists: ${doc.exists}'); // Debug print
      if (doc.exists) {
        final userModel = UserModel.fromFirestore(doc);
        print('Successfully created UserModel for $userId'); // Debug print
        return userModel;
      }
    } catch (e) {
      print('Error fetching user details for $userId: $e'); // Debug print
    }
    return null;
  }

  Future<ProfileModel?> _fetchDriverDetails(String? driverId) async {
    if (driverId == null) {
      print('DriverId is null, skipping driver details fetch'); // Debug print
      return null;
    }

    try {
      print('Fetching driver document for driverId: $driverId'); // Debug print
      final doc =
          await _firestore.collection('driverProfiles').doc(driverId).get();
      print('Driver document exists: ${doc.exists}'); // Debug print
      if (doc.exists) {
        final profileModel = ProfileModel.fromFirestore(doc);
        print('Successfully created ProfileModel for $driverId'); // Debug print
        return profileModel;
      }
    } catch (e) {
      print('Error fetching driver details for $driverId: $e'); // Debug print
    }
    return null;
  }
}
