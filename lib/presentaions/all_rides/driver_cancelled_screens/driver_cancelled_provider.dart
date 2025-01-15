import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/driver_cancelled_screens/cancelled_model.dart';

class DriverCancelledProvider extends ChangeNotifier {
  final _database = FirebaseDatabase.instance.ref();
  final _firestore = FirebaseFirestore.instance;
  List<DriverCancelledBooking> _cancelledBookings = [];
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<DriverCancelledBooking> get cancelledBookings => _cancelledBookings;

  Future<void> fetchDriverCancelledBookings() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      print('Fetching cancelled bookings...');
      final snapshot = await _database.child('driverCancelledBookings').get();

      if (!snapshot.exists || snapshot.value == null) {
        print('No cancelled bookings found');
        _cancelledBookings = [];
        return;
      }

      final bookings = <DriverCancelledBooking>[];
      final driversMap = snapshot.value as Map<Object?, Object?>;

      // Iterate through each driver
      await Future.forEach(driversMap.entries,
          (MapEntry<Object?, Object?> driverEntry) async {
        final driverId = driverEntry.key.toString();
        final driverBookingsMap = driverEntry.value as Map<Object?, Object?>;

        print('Processing driver: $driverId');

        // Fetch driver details from Firestore
        print('Fetching driver details from Firestore for driver: $driverId');
        final driverDetails = await _fetchDriverDetails(driverId);
        print('Driver details result: $driverDetails');

        // Iterate through each booking for this driver
        await Future.forEach(driverBookingsMap.entries,
            (MapEntry<Object?, Object?> bookingEntry) async {
          final bookingId = bookingEntry.key.toString();
          final cancelDetails = bookingEntry.value as Map<Object?, Object?>;

          print('Processing booking: $bookingId');

          // Get the full booking details
          final bookingDetails = await _fetchBookingDetails(bookingId);
          if (bookingDetails == null) {
            print('No booking details found for $bookingId');
            return;
          }

          // Get user details from Firestore
          final userId = bookingDetails['userId']?.toString();
          if (userId == null) {
            print('No userId found for booking $bookingId');
            return;
          }

          print('Fetching user details from Firestore for user: $userId');
          final userDetails = await _fetchUserDetails(userId);
          print('User details result: $userDetails');

          // Combine all data
          final completeBookingData = {
            ...bookingDetails,
            'bookingId': bookingId,
            'driverId': driverId,
            'cancelledAt': cancelDetails['cancelledAt'],
            'driverDetails': driverDetails ?? {},
            'userDetails': userDetails ?? {},
          };

          try {
            final booking =
                DriverCancelledBooking.fromJson(completeBookingData);
            bookings.add(booking);
            print(
                'Successfully added booking: $bookingId with driver: ${driverDetails?['name']} and user: ${userDetails?['name']}');
          } catch (e) {
            print('Error creating booking object for $bookingId: $e');
          }
        });
      });

      _cancelledBookings = bookings;
      print('Total cancelled bookings loaded: ${bookings.length}');
    } catch (e) {
      print('Error fetching cancelled bookings: $e');
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> _fetchDriverDetails(String driverId) async {
    try {
      print('Fetching driver details from Firestore for ID: $driverId');
      final docSnapshot =
          await _firestore.collection('driverProfiles').doc(driverId).get();

      if (!docSnapshot.exists) {
        print('No driver document found in Firestore');
        return null;
      }

      return docSnapshot.data();
    } catch (e) {
      print('Error fetching driver details from Firestore: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _fetchUserDetails(String userId) async {
    try {
      print('Fetching user details from Firestore for ID: $userId');
      final docSnapshot =
          await _firestore.collection('users').doc(userId).get();

      if (!docSnapshot.exists) {
        print('No user document found in Firestore');
        return null;
      }

      return docSnapshot.data();
    } catch (e) {
      print('Error fetching user details from Firestore: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> _fetchBookingDetails(String bookingId) async {
    try {
      final snapshot = await _database.child('bookings/$bookingId').get();
      if (!snapshot.exists) return null;

      final data = snapshot.value as Map<Object?, Object?>;
      return Map<String, dynamic>.fromEntries(
        data.entries.map((e) => MapEntry(e.key.toString(), e.value)),
      );
    } catch (e) {
      print('Error fetching booking details: $e');
      return null;
    }
  }
}
