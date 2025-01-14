import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:zoomio_adminzoomio/presentaions/all_rides/trip_model.dart';

class TripProvider with ChangeNotifier {
  final DatabaseReference _tripRef = FirebaseDatabase.instance.ref('bookings');
  List<Trip> _trips = [];
  bool _isLoading = false;
  String? _error;

  List<Trip> get trips => _trips;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Trip> get completedTrips {
    final completed = _trips.where((trip) {
      // Debug print for each trip's status
      print('Trip ID: ${trip.tripId}, Status: ${trip.status}');
      return trip.status.toLowerCase() == 'trip completed';
    }).toList();

    // Debug print total counts
    print('Total trips: ${_trips.length}');
    print('Completed trips found: ${completed.length}');
    return completed;
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

        data.forEach((key, value) {
          if (value is Map) {
            final tripData = Map<String, dynamic>.from(value);
            // Debug print raw trip data
            print('Raw trip data for $key: $tripData');
            _trips.add(Trip.fromJson(tripData, key.toString()));
          }
        });

        // Sort by timestamp, newest first
        _trips.sort((a, b) => b.timestamp.compareTo(a.timestamp));

        // Debug print all trips after parsing
        for (var trip in _trips) {
          print('Parsed trip - ID: ${trip.tripId}, Status: ${trip.status}');
        }
      }
    } catch (e) {
      _error = 'Failed to fetch trips: $e';
      print('Error fetching trips: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void startRealtimeUpdates() {
    _tripRef.onValue.listen(
      (event) {
        if (event.snapshot.exists) {
          _trips = [];
          final data = event.snapshot.value as Map<dynamic, dynamic>;

          data.forEach((key, value) {
            if (value is Map) {
              final tripData = Map<String, dynamic>.from(value);
              print('Realtime update - Raw trip data for $key: $tripData');
              _trips.add(Trip.fromJson(tripData, key.toString()));
            }
          });

          _trips.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          notifyListeners();
        }
      },
      onError: (error) {
        _error = 'Error in realtime updates: $error';
        print('Realtime update error: $error');
        notifyListeners();
      },
    );
  }
}
