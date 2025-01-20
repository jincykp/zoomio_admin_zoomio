import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class RevenueProvider with ChangeNotifier {
  double _dailyRevenue = 0;
  double _weeklyRevenue = 0;
  double _monthlyRevenue = 0;

  int _dailyTrips = 0;
  int _weeklyTrips = 0;
  int _monthlyTrips = 0;

  final _database = FirebaseDatabase.instance.ref();

  // Getters
  double get dailyRevenue => _dailyRevenue;
  double get weeklyRevenue => _weeklyRevenue;
  double get monthlyRevenue => _monthlyRevenue;
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
      // Reset counters
      _dailyRevenue = 0;
      _weeklyRevenue = 0;
      _monthlyRevenue = 0;
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

          // Update counters based on date
          if (bookingDate.isAfter(today)) {
            _dailyRevenue += totalFare;
            _dailyTrips++;
          }
          if (bookingDate.isAfter(weekStart)) {
            _weeklyRevenue += totalFare;
            _weeklyTrips++;
          }
          if (bookingDate.isAfter(monthStart)) {
            _monthlyRevenue += totalFare;
            _monthlyTrips++;
          }
        } catch (e) {
          print('Error processing booking $key: $e');
        }
      });

      print('Fetched Data:');
      print('Daily Revenue: $_dailyRevenue, Trips: $_dailyTrips');
      print('Weekly Revenue: $_weeklyRevenue, Trips: $_weeklyTrips');
      print('Monthly Revenue: $_monthlyRevenue, Trips: $_monthlyTrips');

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
