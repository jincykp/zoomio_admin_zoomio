import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RevenueProvider with ChangeNotifier {
  double _dailyRevenue = 0;
  double _weeklyRevenue = 0;
  double _monthlyRevenue = 0;

  double _dailyDriverEarnings = 0;
  double _weeklyDriverEarnings = 0;
  double _monthlyDriverEarnings = 0;

  double _dailyAdminEarnings = 0;
  double _weeklyAdminEarnings = 0;
  double _monthlyAdminEarnings = 0;

  int _dailyTrips = 0;
  int _weeklyTrips = 0;
  int _monthlyTrips = 0;

  final _database = FirebaseDatabase.instance.ref();

  // Getters
  double get dailyRevenue => _dailyRevenue;
  double get weeklyRevenue => _weeklyRevenue;
  double get monthlyRevenue => _monthlyRevenue;

  double get dailyDriverEarnings => _dailyDriverEarnings;
  double get weeklyDriverEarnings => _weeklyDriverEarnings;
  double get monthlyDriverEarnings => _monthlyDriverEarnings;

  double get dailyAdminEarnings => _dailyAdminEarnings;
  double get weeklyAdminEarnings => _weeklyAdminEarnings;
  double get monthlyAdminEarnings => _monthlyAdminEarnings;

  int get dailyTrips => _dailyTrips;
  int get weeklyTrips => _weeklyTrips;
  int get monthlyTrips => _monthlyTrips;

  // Parse timestamp string to DateTime
  DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is String) {
      return DateTime.parse(timestamp);
    } else if (timestamp is int) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    throw FormatException('Invalid timestamp format');
  }

  Future<void> fetchData() async {
    try {
      // Reset all counters
      _dailyRevenue = 0;
      _weeklyRevenue = 0;
      _monthlyRevenue = 0;
      _dailyDriverEarnings = 0;
      _weeklyDriverEarnings = 0;
      _monthlyDriverEarnings = 0;
      _dailyAdminEarnings = 0;
      _weeklyAdminEarnings = 0;
      _monthlyAdminEarnings = 0;
      _dailyTrips = 0;
      _weeklyTrips = 0;
      _monthlyTrips = 0;

      final bookingsSnapshot = await _database.child('bookings').get();

      if (!bookingsSnapshot.exists) {
        print('No bookings data found');
        notifyListeners();
        return;
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final weekStart = today.subtract(Duration(days: today.weekday - 1));
      final monthStart = DateTime(now.year, now.month, 1);

      final bookings = bookingsSnapshot.value as Map<dynamic, dynamic>;

      bookings.forEach((key, value) {
        try {
          if (value is! Map) return;

          // Check if status is 'trip completed'
          if (value['status'] != 'trip_completed') return;

          // Parse the timestamp
          DateTime? bookingDate;
          try {
            bookingDate = _parseTimestamp(value['timestamp']);
          } catch (e) {
            print('Error parsing timestamp for booking $key: $e');
            return;
          }

          // Parse total price
          double? totalFare;
          try {
            totalFare = double.parse(value['totalPrice'].toString());
          } catch (e) {
            print('Error parsing totalPrice for booking $key: $e');
            return;
          }

          // Calculate driver and admin earnings
          final driverEarnings = totalFare * 0.4;
          final adminEarnings = totalFare * 0.6;

          // Update counters based on date
          if (bookingDate.isAfter(today)) {
            _dailyRevenue += totalFare;
            _dailyDriverEarnings += driverEarnings;
            _dailyAdminEarnings += adminEarnings;
            _dailyTrips++;
          }
          if (bookingDate.isAfter(weekStart)) {
            _weeklyRevenue += totalFare;
            _weeklyDriverEarnings += driverEarnings;
            _weeklyAdminEarnings += adminEarnings;
            _weeklyTrips++;
          }
          if (bookingDate.isAfter(monthStart)) {
            _monthlyRevenue += totalFare;
            _monthlyDriverEarnings += driverEarnings;
            _monthlyAdminEarnings += adminEarnings;
            _monthlyTrips++;
          }
        } catch (e) {
          print('Error processing booking $key: $e');
        }
      });

      print('Fetched Data:');
      print(
          'Daily Revenue: $_dailyRevenue, Driver: $_dailyDriverEarnings, Admin: $_dailyAdminEarnings, Trips: $_dailyTrips');
      print(
          'Weekly Revenue: $_weeklyRevenue, Driver: $_weeklyDriverEarnings, Admin: $_weeklyAdminEarnings, Trips: $_weeklyTrips');
      print(
          'Monthly Revenue: $_monthlyRevenue, Driver: $_monthlyDriverEarnings, Admin: $_monthlyAdminEarnings, Trips: $_monthlyTrips');

      notifyListeners();
    } catch (e) {
      print('Error in fetchData: $e');
      rethrow;
    }
  }

  void startRealtimeUpdates() {
    _database.child('bookings').onValue.listen(
      (event) {
        if (event.snapshot.exists) {
          fetchData();
        }
      },
      onError: (error) {
        print('Error in realtime updates: $error');
      },
    );
  }
}
